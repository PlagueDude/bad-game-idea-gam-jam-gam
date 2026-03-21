extends Area2D

@export var interact_start : String
@export var interact_bonus : String
@export var unlock_sprint : bool = false
@export var lock_sprint : bool = false
@export var walk_in : bool = false
@export var attack_unlocked : bool = false
@export var attack_locked : bool = false
@export var activate_boss1 : bool = false

var has_been_interacted = false
var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

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
	
	Dialogic.timeline_ended.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)

func _on_dialogue_finished():
	# Apply unlocks
	if unlock_sprint:
		Gamemanager.sprint_unlocked = true
	elif lock_sprint:
		Gamemanager.sprint_unlocked = false

	if attack_unlocked:
		Gamemanager.attack_unlocked = true
	elif attack_locked:
		Gamemanager.attack_unlocked = false

	# Activate boss if flagged
	if activate_boss1:
		var boss_node = get_parent()
		if boss_node and boss_node.has_method("activate_enemy"):
			boss_node.activate_enemy()
		queue_free()

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	player_inside = true
	if walk_in and not has_been_interacted:
		interact()

func _on_body_exited(body):
	if not body.is_in_group("Player"):
		return
	player_inside = false

func _process(_delta):
	if walk_in:
		return

	if player_inside and Input.is_action_just_pressed("interact"):
		interact()
