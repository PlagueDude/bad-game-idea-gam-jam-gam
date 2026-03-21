extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer

var speed := 20.0
var health := 3
var invincible := false
var active := false
var can_act := false
var player_hit_cooldown := false
var knockback_distance := 32.0
var knockback_time := 0.2
var attack_range := 16.0
var hit_cooldown_time := 0.5

func _ready():
	velocity = Vector2.ZERO
	set_physics_process(false)
	anim.play("idle")

func _get_player_node():
	var current_scene = get_tree().current_scene
	if current_scene.has_node("Player"):
		return current_scene.get_node("Player")
	return null

func activate_enemy() -> void:
	if active:
		return
	active = true
	set_physics_process(true)
	can_act = false
	anim.play("emerge")
	await anim.animation_finished
	anim.play("walk_down")
	can_act = true

func _physics_process(_delta):
	if not can_act:
		return
	var player_node = _get_player_node()
	if player_node == null:
		return

	var direction = (player_node.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	check_player_hit(player_node)

func check_player_hit(player_node):
	if player_hit_cooldown:
		return
	if global_position.distance_to(player_node.global_position) <= attack_range:
		player_hit_cooldown = true
		if player_node.has_method("take_damage"):
			player_node.take_damage(1, global_position)
		start_hit_cooldown()

func start_hit_cooldown():
	var t = Timer.new()
	t.wait_time = hit_cooldown_time
	t.one_shot = true
	add_child(t)
	t.start()
	t.timeout.connect(func():
		player_hit_cooldown = false
		t.queue_free()
	)

func take_damage(amount: int, attacker_pos: Vector2) -> void:
	if invincible or health <= 0:
		return
	health -= amount
	if health <= 0:
		await die()
		return

	invincible = true
	can_act = false
	anim.play("hurt")

	var knock_dir = (global_position - attacker_pos).normalized()
	await move_knockback(knock_dir)

	await anim.animation_finished
	var t = Timer.new()
	t.wait_time = 0.5
	t.one_shot = true
	add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	invincible = false
	can_act = true
	anim.play("walk_down")

func move_knockback(direction: Vector2) -> void:
	var elapsed := 0.0
	var start_pos = global_position
	var target_pos = start_pos + direction * knockback_distance
	while elapsed < knockback_time:
		var t = elapsed / knockback_time
		global_position = start_pos.lerp(target_pos, t)
		elapsed += get_process_delta_time()
		await get_tree().process_frame
	global_position = target_pos

func die() -> void:
	var player_node = _get_player_node()
	if player_node != null and player_node.has_method("die"):
		player_node.die()
	can_act = false
	set_physics_process(false)
	anim.play("hurt")
	Dialogic.start("res://Timelines/FrontGameLines/MonsterLines/MonsterLine2.dtl")
	await Dialogic.timeline_ended
	queue_free()
