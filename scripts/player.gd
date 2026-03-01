# Player.gd
extends CharacterBody2D

@export var walk_speed = 150.0
@export var sprint_speed = 230.0
@export var acceleration = 3000.0
@export var friction = 4000.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()
	
	var current_speed = walk_speed
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	
	var target_velocity = direction * current_speed
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
