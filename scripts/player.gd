extends CharacterBody2D

@export var walk_speed = 15.0
@export var sprint_speed = 30.0
@export var acceleration = 3000.0
@export var friction = 4000.0
@export var gravity_strength = 400.0
@export var sprint_unlocked = true

@onready var sprint_particles = $SprintParticles
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	var sprinting = sprint_unlocked and Input.is_action_pressed("sprint")
	var current_speed = sprint_speed if sprinting else walk_speed
	
	var target_velocity = direction * current_speed
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if direction != Vector2.ZERO:
		velocity += direction * gravity_strength * delta
	
	move_and_slide()
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("walk_right")
			else:
				anim.play("walk_left")
		else:
			if direction.y > 0:
				anim.play("walk_down")
			else:
				anim.play("walk_up")
	else:
		anim.stop()
	
	if sprinting and direction != Vector2.ZERO:
		sprint_particles.emitting = true
		if abs(direction.x) > abs(direction.y):
			sprint_particles.rotation_degrees = -90 if direction.x > 0 else 90
		else:
			sprint_particles.rotation_degrees = 0 if direction.y > 0 else 180
	else:
		sprint_particles.emitting = false
