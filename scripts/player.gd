extends CharacterBody2D

@export var walk_speed = 50.0
@export var sprint_speed = 100.0
@export var acceleration = 3000.0
@export var friction = 4000.0
@export var gravity_strength = 400.0
@export var max_health = 5

@onready var sprint_particles = $SprintParticles
@onready var anim = $AnimationPlayer
@onready var interact_area = $InteractArea
@onready var sword_area = $AttackHitbox
@onready var sprite = $Sprite2D

var health : int
var can_move = true
var last_direction = Vector2.DOWN
var is_attacking = false
var knockback_amount_hurt = 16.0
var knockback_amount_attack = 4.0

func _ready():
	health = max_health
	last_direction = Vector2.DOWN
	play_idle()
	anim.animation_finished.connect(_on_animation_finished)
	if Dialogic:
		Dialogic.timeline_started.connect(func(): can_move = false)
		Dialogic.timeline_ended.connect(func(): can_move = true)
	sword_area.monitoring = false
	sword_area.body_entered.connect(_on_sword_hit)

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
	if Input.is_action_just_pressed("attack") and true:
		start_attack()
		return

	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

	var current_speed = walk_speed
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * current_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

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

	if direction != Vector2.ZERO:
		sprint_particles.emitting = false
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
	is_attacking = true
	AudioController.play_ATTACK()
	can_move = false
	sword_area.monitoring = true
	await get_tree().create_timer(0.2).timeout
	sword_area.monitoring = false

	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			anim.play("attack_right")
			move_knockback(Vector2(-1,0), knockback_amount_attack)
		else:
			anim.play("attack_left")
			move_knockback(Vector2(1,0), knockback_amount_attack)
	else:
		if last_direction.y > 0:
			anim.play("attack_down")
			move_knockback(Vector2(0,-1), knockback_amount_attack)
		else:
			anim.play("attack_up")
			move_knockback(Vector2(0,1), knockback_amount_attack)

func _on_sword_hit(body):
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		body.take_damage(1, global_position)

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

func take_damage(amount, attacker_pos = Vector2.ZERO):
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		die()
		return

	# Hurt feedback
	can_move = false
	sprite.modulate = Color(1,0.5,0.5,0.7) # Tint sprite pale red
	# Hurt audio goes here
	if attacker_pos != Vector2.ZERO:
		var knock_dir = (global_position - attacker_pos).normalized()
		move_knockback(knock_dir, knockback_amount_hurt)
	await get_tree().create_timer(0.3).timeout
	sprite.modulate = Color(1,1,1,1)
	can_move = true

func move_knockback(direction: Vector2, distance: float):
	global_position += direction * distance

func die():
	get_tree().reload_current_scene()
	health = max_health
