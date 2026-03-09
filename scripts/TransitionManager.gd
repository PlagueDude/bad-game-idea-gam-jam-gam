extends CanvasLayer

@onready var fade_rect = $ColorRect

var is_transitioning = false

func _ready():
	fade_rect.anchor_left = 0
	fade_rect.anchor_top = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_bottom = 1
	fade_rect.color.a = 0

func fade_to_scene(scene_path : String) -> void:
	if is_transitioning:
		return
	AudioController.play_OpenDoor()
	is_transitioning = true
	await _fade_out()
	get_tree().change_scene_to_file(scene_path)
	await _fade_in()
	is_transitioning = false

func _fade_out() -> void:
	var steps = 4
	var step_time = 0.09
	for i in range(steps + 1):
		fade_rect.color.a = i / float(steps)
		await get_tree().create_timer(step_time).timeout
	fade_rect.color.a = 1

func _fade_in() -> void:
	var steps = 4
	var step_time = 0.09
	for i in range(steps, -1, -1):
		fade_rect.color.a = i / float(steps)
		await get_tree().create_timer(step_time).timeout
	fade_rect.color.a = 0
	
func exit():
	if is_transitioning:
		return
	AudioController.play_OpenDoor()
	is_transitioning = true
	await _fade_out()
