extends Control

@onready var music = "res://sounds/564436__fester993__forest-ambience-1.wav"
@export var new_music : AudioStream

func _on_start_pressed() -> void:
	AudioController.change_music(new_music)
	Gamemanager.player_last_direction = Vector2.UP
	TransitionManager.fade_to_scene("res://scenes/FrontGameScenes/front_level_1.tscn")


func _on_exit_pressed() -> void:
	await TransitionManager._fade_out()
	get_tree().quit()
