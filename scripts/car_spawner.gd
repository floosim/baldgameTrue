extends Node2D

@export var car_scene : PackedScene
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = Vector2(player.position.x + 1050, 0)
	#if player.is_on_floor() = timer.stop()


func _on_timer_timeout() -> void:
	var car = preload("res://scenes/car.tscn").instantiate()
	car.get_child(0).carHit.connect(_on_carhit)
	car.position = position
	get_parent().add_child(car)


func _on_carhit():
	player.current_state = Global.State.hit
	player.hit_timer.start()
