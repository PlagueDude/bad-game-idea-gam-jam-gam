extends Control

@onready var music = "res://sounds/564436__fester993__forest-ambience-1.wav"
@export var new_music : AudioStream

func _on_start_pressed() -> void:
	AudioController.change_music(new_music)
	TransitionManager.fade_to_scene("res://scenes/TestScenes/node_2d.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
