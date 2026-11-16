#!/usr/bin/env python3
"""Generates every sound of the client. All sounds are synthesised here from
noise and tones, so they belong to the project. Run it after changing a
sound; it rewrites client/audio/*.ogg.

    python3 client/audio/generate.py      # needs numpy and ffmpeg

Atmospheres (amb_*) are seamless mono loops: their noise is shaped in the
frequency domain and every modulation has whole cycles in the loop.
"""
import os
import subprocess
import tempfile
import wave

import numpy as np

SR = 32000
OUT = os.path.dirname(os.path.abspath(__file__))
rng = np.random.default_rng(2847)


def t_axis(seconds):
    return np.arange(int(seconds * SR)) / SR


def noise(seconds, low, high, tilt=0.0):
    """Periodic noise between two frequencies; tilt < 0 favours the lows."""
    n = int(seconds * SR)
    spec = np.fft.rfft(rng.standard_normal(n))
    f = np.fft.rfftfreq(n, 1 / SR)
    shape = 1 / (1 + (low / np.maximum(f, 1)) ** 6) / (1 + (f / high) ** 6)
    shape *= np.maximum(f, 20) ** tilt
    out = np.fft.irfft(spec * shape, n)
    return out / np.max(np.abs(out))


def cycles(seconds, parts):
    """A slow wave 0..1 from (whole cycles, weight) pairs, seamless."""
    t = t_axis(seconds)
    w = sum(weight * np.sin(2 * np.pi * (c * t / seconds + rng.random())) for c, weight in parts)
    w -= w.min()
    return w / w.max()


def env(n, attack, decay):
    t = np.arange(n) / SR
    return np.minimum(t / max(attack, 1e-4), 1) * np.exp(-t / decay)


def tone(freq, seconds, attack=0.004, decay=0.2, harmonics=(1.0,)):
    t = t_axis(seconds)
    out = sum(a * np.sin(2 * np.pi * freq * (i + 1) * t) for i, a in enumerate(harmonics))
    return out * env(len(t), attack, decay)


def place(total_seconds, parts):
    out = np.zeros(int(total_seconds * SR))
    for at, sound in parts:
        i = int(at * SR)
        sound = sound[: len(out) - i]
        out[i : i + len(sound)] += sound
    return out


def click(seconds=0.03, low=800, high=5000, decay=0.006):
    c = noise(seconds, low, high)
    return c * env(len(c), 0.0005, decay)


def save(name, sound, peak=0.8, quality=3):
    sound = sound / np.max(np.abs(sound)) * peak
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        path = tmp.name
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes((sound * 32767).astype("<i2").tobytes())
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", path, "-c:a", "libvorbis", "-q:a", str(quality),
                    os.path.join(OUT, name + ".ogg")], check=True)
    os.unlink(path)
    print("%-12s %5.1f s" % (name, len(sound) / SR))


# --- Atmospheres -----------------------------------------------------------------

def wind(seconds, strength=1.0):
    body = noise(seconds, 90, 700, -0.5) * (0.35 + 0.65 * cycles(seconds, [(1, 1), (3, 0.6), (5, 0.3)]))
    whistle = noise(seconds, 700, 1500) * cycles(seconds, [(2, 1), (5, 0.7), (9, 0.3)]) ** 3
    return body + 0.22 * strength * whistle


def amb_wind():
    # Heard from inside the hut: muffled.
    return wind(12) + 0.25 * noise(12, 40, 160) * cycles(12, [(2, 1), (3, 0.5)])


def amb_sea():
    s = 14
    swell = cycles(s, [(2, 1), (3, 0.35)]) ** 2
    surf = noise(s, 120, 2200, -0.6) * (0.2 + 0.8 * swell)
    rumble = noise(s, 35, 140) * (0.4 + 0.6 * cycles(s, [(2, 1), (1, 0.5)]))
    rain = noise(s, 2500, 9000) * (0.7 + 0.3 * cycles(s, [(4, 1), (7, 0.5)]))
    return surf + 0.7 * rumble + 0.1 * rain + 0.5 * wind(s, 1.4)


def amb_fire():
    s = 8
    out = 0.5 * noise(s, 60, 500, -0.8) * (0.6 + 0.4 * cycles(s, [(5, 1), (11, 0.6)]))
    pops = [(rng.uniform(0.05, s - 0.2), rng.uniform(0.2, 1.0) * click(0.05, 600, 6000, rng.uniform(0.003, 0.012)))
            for _ in range(46)]
    return out + place(s, pops)


def amb_static():
    s = 4
    return noise(s, 400, 5000) * (0.6 + 0.4 * cycles(s, [(3, 1), (7, 0.6), (13, 0.4)])) + 0.15 * np.sin(2 * np.pi * 100 * t_axis(s))


def amb_tick():
    tick = click(0.04, 1500, 6000, 0.004) + 0.5 * tone(2100, 0.04, decay=0.008)
    tock = click(0.04, 900, 4000, 0.005) + 0.5 * tone(1500, 0.04, decay=0.01)
    return place(2, [(0.0, tick), (1.0, tock)])


# --- Effects ------------------------------------------------------------------------

def thunder():
    s = 5
    n = int(s * SR)
    roll = noise(s, 30, 220, -0.6)
    shape = np.zeros(n)
    for at, level, decay in [(0.0, 1.0, 0.5), (0.35, 0.7, 0.9), (1.1, 0.5, 1.2), (2.0, 0.3, 1.2)]:
        i = int(at * SR)
        shape[i:] += level * np.exp(-np.arange(n - i) / SR / decay)
    crack = noise(s, 300, 3000) * env(n, 0.002, 0.12) * 0.5
    out = roll * shape + crack
    out[-SR // 2 :] *= np.linspace(1, 0, SR // 2)
    return out


def unlock():
    clunk = click(0.09, 150, 1800, 0.02) + 0.6 * tone(180, 0.09, decay=0.03)
    return place(0.5, [(0.0, 0.7 * click(0.03, 1500, 6000, 0.004)), (0.09, clunk), (0.2, 0.5 * clunk)])


def chime():
    bell = lambda f: tone(f, 1.2, decay=0.45, harmonics=(1, 0.0, 0.35, 0.0, 0.12))
    return place(1.6, [(0.0, bell(880)), (0.16, bell(1318.5))])


def win():
    bell = lambda f: tone(f, 1.6, decay=0.6, harmonics=(1, 0.2, 0.3, 0.05))
    return place(3.0, [(0.0, bell(523.25)), (0.18, bell(659.25)), (0.36, bell(783.99)), (0.6, bell(1046.5)), (0.6, 0.6 * bell(659.25))])


def match():
    s = 0.7
    n = int(s * SR)
    scrape = noise(s, 2000, 9000) * env(n, 0.01, 0.07)
    flare = noise(s, 300, 4000, -0.3) * np.clip((t_axis(s) - 0.12) / 0.05, 0, 1) * np.exp(-np.maximum(t_axis(s) - 0.12, 0) / 0.2)
    return scrape + 0.9 * flare


def hum():
    s = 1.4
    t = t_axis(s)
    rise = np.minimum(t / 0.9, 1)
    return (np.sin(2 * np.pi * np.cumsum(60 + 60 * rise) / SR) + 0.4 * np.sin(2 * np.pi * np.cumsum(180 + 180 * rise) / SR)) * rise * np.minimum((s - t) / 0.3, 1)


def beep(seconds):
    t = t_axis(seconds + 0.02)
    edge = np.minimum(np.minimum(t / 0.006, 1), np.maximum((seconds + 0.02 - t) / 0.02, 0))
    return np.sin(2 * np.pi * 720 * t) * edge


def pour():
    s = 0.9
    return noise(s, 500, 3500) * cycles(s, [(9, 1), (17, 0.6)]) * env(int(s * SR), 0.05, 0.4) + 0.3 * tone(420, s, 0.05, 0.3)


def gear():
    return place(0.5, [(i * 0.06, (1 - i * 0.1) * click(0.03, 1200, 5000, 0.004)) for i in range(7)])


def step():
    creak = noise(0.25, 200, 900) * env(int(0.25 * SR), 0.03, 0.08)
    foot = click(0.08, 60, 500, 0.03)
    return place(0.6, [(0.0, foot), (0.05, 0.3 * creak), (0.3, 0.8 * foot)])


SOUNDS = {
    "amb_wind": (amb_wind, 0.5), "amb_sea": (amb_sea, 0.6), "amb_fire": (amb_fire, 0.5),
    "amb_static": (amb_static, 0.3), "amb_tick": (amb_tick, 0.3),
    "thunder": (thunder, 0.9),
    "tap": (lambda: click(0.05, 500, 3000, 0.008) + 0.4 * tone(520, 0.05, decay=0.015), 0.4),
    "pick": (lambda: place(0.3, [(0, tone(660, 0.12, decay=0.05)), (0.07, tone(990, 0.2, decay=0.07))]), 0.45),
    "tick": (lambda: click(0.04, 1200, 6000, 0.005) + 0.5 * tone(1400, 0.04, decay=0.008), 0.5),
    "unlock": (unlock, 0.8), "chime": (chime, 0.55), "win": (win, 0.7),
    "thud": (lambda: click(0.2, 60, 400, 0.05) + tone(110, 0.2, decay=0.05), 0.6),
    "match": (match, 0.6), "hum": (hum, 0.6),
    "beep_s": (lambda: beep(0.12), 0.5), "beep_l": (lambda: beep(0.4), 0.5),
    "pour": (pour, 0.5), "gear": (gear, 0.5), "step": (step, 0.45),
    "cuckoo": (lambda: place(1.0, [(0, tone(988, 0.3, 0.02, 0.2, (1, 0.3))), (0.38, tone(784, 0.5, 0.02, 0.3, (1, 0.3)))]), 0.6),
}

if __name__ == "__main__":
    for name, (make, peak) in SOUNDS.items():
        save(name, make(), peak)
