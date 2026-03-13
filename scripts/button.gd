extends Sprite2D

func pressed():
	frame = 1
	owner.push_order(get_index())
	AudioController.play_ButtonClick()

func unpressed():
	frame = 0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		pressed()

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		unpressed()
