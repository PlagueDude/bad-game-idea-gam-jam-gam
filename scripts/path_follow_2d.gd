extends PathFollow2D

@export var speed: float = 0.11

func _process(delta: float) -> void:
	progress_ratio += speed * delta
