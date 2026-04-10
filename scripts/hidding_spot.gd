extends Node2D

@onready var player: CharacterBody2D = $"../Player"

var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_in_range == true and player.current_state == Global.State.hidden:
		player.position = position
	if player_in_range == true and Input.is_action_just_released("hide"):
		player.position = Vector2(position.x + 0, 200)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
