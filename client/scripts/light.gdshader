// Darkness over the room, with pools of light: up to four warm ones (lamp,
// stove) that flicker, and one cold one (the window). Each light is
// (x, y, radius, strength) in scene pixels; strength 0 is off.
shader_type canvas_item;
render_mode blend_premul_alpha;

uniform vec2 size = vec2(960.0, 472.0);
uniform float dark = 0.85;
uniform vec4 warm0 = vec4(0.0);
uniform vec4 warm1 = vec4(0.0);
uniform vec4 warm2 = vec4(0.0);
uniform vec4 warm3 = vec4(0.0);
uniform vec4 cold = vec4(0.0);

float pool(vec4 l, vec2 p) {
	if (l.w <= 0.0) {
		return 0.0;
	}
	float d = distance(p, l.xy) / l.z;
	return l.w * (1.0 - smoothstep(0.0, 1.0, d));
}

float grain(vec2 p) {
	return fract(sin(dot(floor(p / 2.0), vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 p = UV * size;
	float flicker = 0.94 + 0.04 * sin(TIME * 9.0) + 0.02 * sin(TIME * 23.0 + 1.3);
	float w = (pool(warm0, p) + pool(warm1, p) + pool(warm2, p) + pool(warm3, p)) * flicker;
	float c = pool(cold, p);
	float lit = clamp(w + c, 0.0, 1.0);
	vec2 q = UV - vec2(0.5);
	float vignette = smoothstep(0.35, 0.85, length(q * vec2(1.0, 0.8)));
	float a = clamp(dark * (1.0 - lit) + 0.35 * vignette * dark, 0.0, 0.97);
	a += (grain(p) - 0.5) * 0.03 * a;
	vec3 glow = vec3(1.0, 0.6, 0.22) * min(w, 1.2) * 0.13 + vec3(0.4, 0.55, 0.9) * c * 0.10;
	COLOR = vec4(glow * (1.0 - a * 0.5), a);
}
