extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"

@export var speed: int = 500
@export var chase_speed: int = 1500
@export var acceleration: int = 3000

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast: RayCast2D = $Sprite2D/RayCast2D
@onready var timer: Timer = $Timer
@onready var blind_timer: Timer = $BlindTimer

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2


enum States{
	wander,
	chase,
	blinded
}
var current_state = States.wander

func _ready() -> void:
	left_bounds = self.position + Vector2(-1250, 0)
	right_bounds = self.position + Vector2(1250, 0)
	player.Blind.connect(_blinded)


func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	if current_state != States.blinded:
		handle_movement(delta)
	change_direction()
	look_for_player()
	


func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player and current_state != States.blinded:
			chase_player()
		elif current_state == States.chase:
			stop_chase()
	elif current_state == States.chase:
		stop_chase()


func chase_player() -> void:
	timer.stop()
	current_state = States.chase


func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()


func handle_movement(delta: float) -> void:
	if current_state == States.wander:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(direction * chase_speed, acceleration * delta)
	
	move_and_slide()


func change_direction() -> void:
	if current_state == States.wander:
		if sprite.flip_h:
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)
			else:
				sprite.flip_h = false
				ray_cast.target_position = Vector2(-1250, 0)
		else:
			if self.position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
			else:
				sprite.flip_h = true
				ray_cast.target_position = Vector2(1250, 0)
	else:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			sprite.flip_h = true
			ray_cast.target_position = Vector2(1250, 0)
		else:
			sprite.flip_h = false
			ray_cast.target_position = Vector2(-1250, 0)


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func _on_timer_timeout():
	current_state = States.wander


func _on_push_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and current_state != States.blinded:
		_on_push()
		body.velocity.y = -1000
		body.velocity.x = -1000
		print("hit")

func _on_push():
	player.current_state = Global.State.hit
	player.hit_timer.start()

func _blinded():
	current_state = States.blinded
	blind_timer.start()

func _on_blind_timer_timeout() -> void:
	current_state = States.chase
