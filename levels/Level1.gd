extends Node2D

func _ready():
	add_to_group("level")
	pause()

func _process(delta):
	pass

func pause():
	$PauseMenu.show()
	get_tree().paused = true

func unpause():
	$PauseMenu.hide()
	get_tree().paused = false

func reset():
	print("reset called")
