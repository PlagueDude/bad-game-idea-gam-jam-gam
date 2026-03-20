extends CharacterBody2D

@export var walk_speed = 50.0
@export var sprint_speed = 100.0
@export var acceleration = 3000.0
@export var friction = 4000.0
@export var gravity_strength = 400.0
@export var health = 3

@onready var sprint_particles = $SprintParticles
@onready var anim = $AnimationPlayer
@onready var interact_area = $InteractArea

var can_move = true
var last_direction = Vector2.DOWN
var is_attacking = false

func _ready():
	last_direction = Gamemanager.player_last_direction
	play_idle()
	anim.animation_finished.connect(_on_animation_finished)
	if Dialogic:
		Dialogic.timeline_started.connect(func(): can_move = false)
		Dialogic.timeline_ended.connect(func(): can_move = true)

func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		play_idle()
		return

	if Input.is_action_just_pressed("interact"):
		try_interact()

	if Input.is_action_just_pressed("attack") and Gamemanager.attack_unlocked:
		start_attack()
		return

	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

	var sprinting = Gamemanager.sprint_unlocked and Input.is_action_pressed("sprint")
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
				anim.play("walk_left")
			else:
				anim.play("walk_right")
		else:
			if direction.y > 0:
				anim.play("walk_down")
			else:
				anim.play("walk_up")
	else:
		play_idle()

	if sprinting and direction != Vector2.ZERO:
		sprint_particles.emitting = true
		if abs(direction.x) > abs(direction.y):
			sprint_particles.rotation_degrees = -90 if direction.x > 0 else 90
		else:
			sprint_particles.rotation_degrees = 0 if direction.y > 0 else 180
	else:
		sprint_particles.emitting = false

func play_idle():
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			anim.play("idle_left")
		else:
			anim.play("idle_right")
	else:
		if last_direction.y > 0:
			anim.play("idle_down")
		else:
			anim.play("idle_up")

func start_attack():
	if is_attacking:
		return
	AudioController.play_ATTACK()
	is_attacking = true
	can_move = false

	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			anim.play("attack_right")
		else:
			anim.play("attack_left")
	else:
		if last_direction.y > 0:
			anim.play("attack_down")
		else:
			anim.play("attack_up")

func _on_animation_finished(anim_name):
	if is_attacking and anim_name in ["attack_left","attack_right","attack_down","attack_up"]:
		is_attacking = false
		can_move = true

func try_interact():
	var areas = interact_area.get_overlapping_areas()
	for area in areas:
		if area.has_method("interact"):
			area.interact()
			return
