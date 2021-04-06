extends Node2D

var baracade = load("res://components/Baracade.tscn")

func _ready():
	print("Level Ready")
	add_to_group("level")
	var baracade_positions = $Baracades.get_children()
	for pos in baracade_positions:
		var clone = baracade.instance()
		pos.add_child(clone)
	pause()

func _process(delta):
	pass

func pause():
	$PauseMenu.show()
	get_tree().paused = true

func unpause():
	$PauseMenu.hide()
	get_tree().paused = false

func update_ui_lives(lives):
	$GameInfo.set_lives(lives)

func increment_score(inc):
	$GameInfo.increment_score(inc)

func new_round(new_game):
	get_tree().call_group("projectile", "destroy_self")
	$InvaderController.new_round(new_game)
	var baracade_positions = $Baracades.get_children()
	for pos in baracade_positions:
		for child in pos.get_children():
			child.queue_free()
			
		var clone = baracade.instance()
		pos.call_deferred('add_child', clone)
	pause()
