extends Node

@onready var level_root: Node2D = $"../LevelRoot"
@onready var player: Node2D = $"../LevelRoot/Player"

func _ready() -> void:
	level_root.endLevel.connect(endLevel1)

func endLevel1(body: Node2D):
	if body.is_in_group("player"):
		print("Level 1 done!")
		player.current_level = Global.Level.TWO
		get_tree().change_scene_to_file("res://scenes/level2.tscn")
