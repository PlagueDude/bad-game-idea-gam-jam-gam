extends Node2D

@onready var music = $Music
var mute: bool = false

func set_mute(value: bool):
	mute = value
	if mute:
		music.stop()
	else:
		if not music.playing:
			music.play()

func change_music(new_stream: AudioStream):
	var tween = create_tween()
	tween.tween_property(music, "volume_db", -40, 1.0)
	await tween.finished
	music.stop()
	music.stream = new_stream
	if not mute:
		music.play()
	music.volume_db = -40
	var tween2 = create_tween()
	tween2.tween_property(music, "volume_db", 0, 1.0)

func play_OpenDoor():
	$OpenDoor.play()

func play_PushBlock():
	$PushBlock.play()

func play_GotCaught():
	$GotCaught.play()
