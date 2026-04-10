extends Node2D

@onready var win_area: Area2D = $WinArea

signal endLevel

func _on_win_area_body_entered(area: Node2D) -> void:
	print("Here")
	endLevel.emit(area)
