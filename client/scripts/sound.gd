## Sound: looping atmospheres that fade into each other (bus "Ambience") and
## short effects (bus "Effects"). The sounds are made by
## client/audio/generate.py. The buses come from default_bus_layout.tres (the
## web build only routes buses from the layout to the speakers).
class_name Sound
extends Node

const FADE_PER_SECOND := 1.6

var muted := false
## Names of the effects played, newest last (for tests).
var history: Array[String] = []

var _streams := {}
var _pool: Array[AudioStreamPlayer] = []
## Atmosphere name -> its player; _wanted has the level each should reach.
var _loops := {}
var _wanted := {}


func _ready() -> void:
	for i in 8:
		var p := AudioStreamPlayer.new()
		p.bus = "Effects"
		add_child(p)
		_pool.append(p)


func _stream(name: String) -> AudioStream:
	if not _streams.has(name):
		var path := "res://audio/%s.ogg" % name
		_streams[name] = load(path) if ResourceLoader.exists(path) else null
	return _streams[name]


func play(name: String, gain_db: float = 0.0, pitch_jitter: float = 0.03) -> void:
	history.append(name)
	if history.size() > 200:
		history.pop_front()
	var stream := _stream(name)
	if stream == null:
		return
	var player: AudioStreamPlayer = _pool[0]
	for p in _pool:
		if not p.playing:
			player = p
			break
	player.stream = stream
	player.volume_db = gain_db
	player.pitch_scale = 1.0 + randf_range(-pitch_jitter, pitch_jitter)
	player.play()


## The atmospheres to hear now: name -> level 0..1. Others fade out.
func ambience(levels: Dictionary) -> void:
	_wanted = levels
	for name in levels:
		if not _loops.has(name):
			var stream := _stream(name)
			if stream == null:
				continue
			if stream is AudioStreamOggVorbis:
				stream.loop = true
			var p := AudioStreamPlayer.new()
			p.bus = "Ambience"
			p.stream = stream
			p.volume_db = -60.0
			add_child(p)
			_loops[name] = p


func _process(delta: float) -> void:
	for name in _loops:
		var p: AudioStreamPlayer = _loops[name]
		var target: float = _wanted.get(name, 0.0)
		var now := db_to_linear(p.volume_db) if p.playing else 0.0
		var next := move_toward(now, target, FADE_PER_SECOND * delta)
		if next <= 0.001:
			if p.playing:
				p.stop()
			continue
		if not p.playing:
			p.play(randf() * 2.0)
		p.volume_db = linear_to_db(next)


func set_muted(off: bool) -> void:
	muted = off
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), off)
