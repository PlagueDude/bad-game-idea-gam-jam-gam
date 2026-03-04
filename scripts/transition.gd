extends Area2D

@export var next_scene : String

func _ready():
	connect("body_entered", Callable(self, "_on_area_body_entered"))

func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		body.can_move = false
		await _start_transition()

func _start_transition() -> void:
	await TransitionManager.fade_to_scene(next_scene)
