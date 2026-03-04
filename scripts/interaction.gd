extends Area2D

@export var interact_start : String
@export var interact_bonus : String

var has_been_interacted = false

func interact():
	if not has_been_interacted:
		if interact_start != "":
			Dialogic.start(interact_start)
		has_been_interacted = true
	else:
		if interact_bonus != "":
			Dialogic.start(interact_bonus)
		elif interact_start != "":
			Dialogic.start(interact_start)
