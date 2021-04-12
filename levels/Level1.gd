extends Node2D

var baracade = load("res://components/Baracade.tscn")
var mother_ship = load("res://actors/MotherShip.tscn")
var zoomed = false
var mother_ship_spawn_left = true

func _ready():
	print("Level Ready")
	add_to_group("level")
	var baracade_positions = $Baracades.get_children()
	for pos in baracade_positions:
		var clone = baracade.instance()
		pos.add_child(clone)
	$MotherShipTimer.connect("timeout", self, "_spawn_mothership")
	$MotherShipTimer.start(25.0)
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
	get_tree().call_group("mothership", "_despawn")
	get_tree().call_group("projectile", "destroy_self")
	$InvaderController.new_round(new_game)
	var baracade_positions = $Baracades.get_children()
	for pos in baracade_positions:
		for child in pos.get_children():
			child.queue_free()
			
		var clone = baracade.instance()
		pos.call_deferred('add_child', clone)
	pause()

# Mothership should just switch between spawning left and right. No random numbers and no dependency on number of shots by player.
func _spawn_mothership():
	var mother_ship_instance = mother_ship.instance()
	add_child(mother_ship_instance)
	if mother_ship_spawn_left:
		mother_ship_instance.global_position = $MotherShipSpawns/left.global_position
		mother_ship_instance.move_right = true
	else:
		mother_ship_instance.global_position = $MotherShipSpawns/right.global_position
		mother_ship_instance.move_right = false
	mother_ship_spawn_left = not mother_ship_spawn_left

func start_mothership_timer():
	$MotherShipTimer.start(25.0)
