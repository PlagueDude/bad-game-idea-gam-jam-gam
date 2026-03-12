extends Area2D

@export var next_scene : String
@export var mute_music : bool = false
@export var new_music : AudioStream
@export var exit_game : bool = false


func _ready():
	connect("body_entered", Callable(self, "_on_area_body_entered"))


func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		body.can_move = false
		Gamemanager.player_last_direction = body.last_direction
		await _start_transition()


func _start_transition() -> void:
	AudioController.set_mute(mute_music)
	if new_music != null:
		AudioController.change_music(new_music)

	if exit_game:
		await TransitionManager.exit()
		get_tree().quit()
	else:
		await TransitionManager.fade_to_scene(next_scene)
