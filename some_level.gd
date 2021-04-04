extends Node2D


func _ready():
	add_to_group("level")
	for invader in $invaders.get_children():
		invader.activate()

func _process(delta):
	pass
#	if $invaders.get_child_count() == 0:
#		call_deferred("end_game")

func end_game():
	print("End Game")
	get_tree().paused = true

func pause():
	$PauseMenu.show()
	get_tree().paused = true

func unpause():
	$PauseMenu.hide()
	get_tree().paused = false

func _on_Area2D_body_entered(body):
	if body is Invader:
		end_game()
