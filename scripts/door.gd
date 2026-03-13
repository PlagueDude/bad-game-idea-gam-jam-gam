extends Sprite2D

func open_door():
	frame = 1
	AudioController.play_OpenDoor()
	%DoorCollision.set_deferred("disabled", true)

func close_door():
	frame = 0
	%DoorCollision.set_deferred("disabled", false)
