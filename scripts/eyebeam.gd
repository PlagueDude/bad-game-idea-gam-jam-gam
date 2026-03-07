extends Node2D

@onready var raycast_2D = $RayCast2D
@onready var raycast_2D2 = $RayCast2D2
@onready var raycast_2D3 = $RayCast2D3
var fading := false

func _physics_process(_delta):
	if fading:
		return

	for raycast in [raycast_2D, raycast_2D2, raycast_2D3]:
		if raycast.is_colliding():
			var body = raycast.get_collider()
			if body.is_in_group("Player"):
				fading = true
				var player = body
				if body.get_parent().is_in_group("Player"):
					player = body.get_parent()
				player.set_physics_process(false)
				await _fade_and_reload()
				break

func _fade_and_reload() -> void:
	Dialogic.end_timeline()
	await TransitionManager._fade_out()
	get_tree().reload_current_scene()
	await TransitionManager._fade_in()
	fading = false
