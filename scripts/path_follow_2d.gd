extends PathFollow2D

@export var speed: float = 0.09

func _process(delta: float) -> void:
	progress_ratio += speed * delta
