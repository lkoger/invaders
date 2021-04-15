extends Node2D

var baracade = load("res://components/Baracade.tscn")
var mother_ship = load("res://actors/MotherShip.tscn")
onready var pause_menu = $UI/PauseMenu
onready var game_info = $UI/GameInfo
var zoomed = false
var mother_ship_spawn_left = true
var mother_ship_instance = null

func _ready():
	add_to_group("game")
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
	pause_menu.show()
	get_tree().paused = true

func unpause():
	pause_menu.hide()
	get_tree().paused = false

func update_ui_lives(lives):
	game_info.set_lives(lives)

func increment_score(inc):
	game_info.increment_score(inc)

func new_round(new_game):
	get_tree().call_group("mothership", "_despawn")
	get_tree().call_group("projectile", "destroy_self")
#	if is_instance_valid(mother_ship_instance):
#		mother_ship_instance._despawn()
	$InvaderController.new_round(new_game)
	var baracade_positions = $Baracades.get_children()
	for pos in baracade_positions:
		for child in pos.get_children():
			child.queue_free()
			
		var clone = baracade.instance()
		pos.call_deferred('add_child', clone)
	if new_game:
		pause_menu.end_game()
		pause()
	#pause()

# Mothership should just switch between spawning left and right. No random numbers and no dependency on number of shots by player.
func _spawn_mothership():
	mother_ship_instance = mother_ship.instance()
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
