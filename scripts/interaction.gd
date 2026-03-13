extends Area2D

@export var interact_start : String
@export var interact_bonus : String
@export var unlock_sprint : bool = false
@export var lock_sprint : bool = false
@export var walk_in : bool = false

var has_been_interacted = false

func interact():
	if unlock_sprint or lock_sprint:
		Dialogic.timeline_ended.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)

	if not has_been_interacted:
		if interact_start != "":
			Dialogic.start(interact_start)
		has_been_interacted = true
	else:
		if interact_bonus != "":
			Dialogic.start(interact_bonus)
		elif interact_start != "":
			Dialogic.start(interact_start)

func _on_dialogue_finished():
	if unlock_sprint:
		Gamemanager.sprint_unlocked = true
	elif lock_sprint:
		Gamemanager.sprint_unlocked = false
