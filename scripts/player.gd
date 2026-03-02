extends CharacterBody2D

@export var walk_speed = 150.0
@export var sprint_speed = 230.0
@export var acceleration = 3000.0
@export var friction = 4000.0
@export var gravity_strength = 400.0 

@onready var sprint_particles = $SprintParticiles

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# If not moving, no gravity effect
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	var current_speed = walk_speed
	var sprinting = Input.is_action_pressed("sprint")
	if sprinting:
		current_speed = sprint_speed
	
	var target_velocity = direction * current_speed
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# --- Apply directional gravity ---
	if direction != Vector2.ZERO:
		velocity += direction * gravity_strength * delta
	
	move_and_slide()
	
	# --- Sprint particles ---
	if sprinting and direction != Vector2.ZERO:
		sprint_particles.emitting = true
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				sprint_particles.rotation_degrees = -90
			else:
				sprint_particles.rotation_degrees = 90
		else:
			if direction.y > 0:
				sprint_particles.rotation_degrees = 0
			else:
				sprint_particles.rotation_degrees = 180
	else:
		sprint_particles.emitting = false
		
