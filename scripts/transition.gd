extends Area2D

enum PushDirection { DOWN, RIGHT }

@export var next_scene : String
@export var mute_music : bool = false
@export var new_music : AudioStream
@export var exit_game : bool = false
@export var push_direction : PushDirection = PushDirection.DOWN

var current_body = null
var locked := false

func _ready():
	connect("body_entered", Callable(self, "_on_area_body_entered"))

func _on_area_body_entered(body):
	if body.is_in_group("Player") and not locked:
		current_body = body
		locked = true
		_lock_player()
		Gamemanager.player_last_direction = body.last_direction
		_start_dialog()

func _lock_player():
	if current_body:
		current_body.can_move = false
		if "velocity" in current_body:
			current_body.velocity = Vector2.ZERO

func _start_dialog():
	Dialogic.start("res://Timelines/Universal Lines/GoOrLeave.dtl")
	Dialogic.signal_event.connect(_on_dialog_signal)

func _on_dialog_signal(arg):
	if arg == "yes":
		await _start_transition()
	elif arg == "no":
		await _cancel_transition()
	Dialogic.signal_event.disconnect(_on_dialog_signal)

func _cancel_transition():
	if current_body:
		_lock_player()
		var target_position = current_body.position

		match push_direction:
			PushDirection.DOWN:
				target_position.y += 12
			PushDirection.RIGHT:
				target_position.x += 12

		var tween = create_tween()
		tween.tween_property(current_body, "position", target_position, 0.4)
		await tween.finished

		current_body.can_move = true
		locked = false

func _start_transition() -> void:
	_lock_player()
	AudioController.set_mute(mute_music)

	if new_music != null:
		AudioController.change_music(new_music)

	if exit_game:
		await TransitionManager.exit()
		get_tree().quit()
	else:
		await TransitionManager.fade_to_scene(next_scene)
