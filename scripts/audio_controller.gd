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
	music.stop()
	music.stream = new_stream
	if not mute:
		music.play()

func play_OpenDoor():
	$OpenDoor.play()

func play_PushBlock():
	$PushBlock.play()

func play_GotCaught():
	$GotCaught.play()
