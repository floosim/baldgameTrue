extends CharacterBody2D

@onready var hit_timer: Timer = $HitTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed = 700.0
const JUMP_VELOCITY = -800.0

var current_state = Global.State.idle

var current_level = Global.Level.ONE

var enemy_in_range = false

signal Blind

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and current_level != Global.Level.THREE:
		current_state = Global.State.jumping
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	if current_state != Global.State.hit:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else: 
			velocity.x = move_toward(velocity.x, 0, speed)
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") and current_state != Global.State.hit:
		current_state = Global.State.running
	elif current_state != Global.State.hit:
		current_state = Global.State.idle
	
	
	if Input.is_action_pressed("bling") and current_state != Global.State.hit:
		current_state = Global.State.bling
		speed = 0
	if Input.is_action_just_released("bling") and current_state != Global.State.hit:
		current_state = Global.State.idle
		speed = 700
	
	if enemy_in_range == true and Input.is_action_pressed("bling"):
		Blind.emit()


	if current_state == Global.State.jumping:
		animated_sprite.play("jumping")
	elif current_state == Global.State.running:
		animated_sprite.play("running")
	elif current_state == Global.State.idle:
		animated_sprite.play("idle")

	
	
	
	move_and_slide()


func _on_hit_timer_timeout() -> void:
	current_state = Global.State.idle


func _on_bling_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_in_range = true
	#if current_state == Global.State.bling and body.is_in_group("enemy"):
		#Blind.emit()


func _on_bling_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_in_range = false


func blind_enemy():
	pass
