extends Node2D

func _ready():
	add_to_group("world")

func end_game():
	get_tree().reload_current_scene()
