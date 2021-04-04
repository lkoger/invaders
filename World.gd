extends Node2D

var player_lives := 3

func _ready():
	add_to_group("world")

func end_game():
	player_lives -= 1
	
	if player_lives <= 0:
		print("Game Over")
		get_tree().reload_current_scene()
	else:
		$Level1.reset()
