extends Node2D

var invader = load("res://actors/Invader.tscn")
onready var defender = load("res://actors/Player.tscn").instance()
var rows := 5
var columns := 11
var time_offset := 1
var row_time_offset := 4
var time_counter := time_offset
var row_idx := 0
var col_idx := 0
var invader_idx := 0
var num_invaders := rows * columns

export var movement_delay := 0
var speed := 1

enum {INIT, ACTIVATE, ACTIVE, INACTIVE, END}
var state = INIT

var start_drop := false
var drop := false

onready var invaders = $invaders

func _ready():
	add_to_group("invader_controller")
	print("HEY!")

func _process(delta):
	if state == INIT:
		_init_invaders(delta)
	elif state == ACTIVATE:
		_activate(delta)
	
	if not state == ACTIVE:
		time_counter = max(0, time_counter-1)

func _init_invaders(delta):
	if row_idx < rows and time_counter == 0:
		var invader_instance = invader.instance()
		invader_instance.row = row_idx
		invaders.add_child(invader_instance)
		invader_instance.position = Vector2((col_idx*64) - (64*columns*0.5), -row_idx*48)

		col_idx += 1
		if col_idx == columns:
			col_idx = 0
			row_idx += 1
		time_counter = time_offset
	elif row_idx == rows:
		print("ACTIVATE")
		_change_state(ACTIVATE)
		row_idx = 0
		col_idx = 0


func _activate(delta):
	row_idx += 1
	time_counter = row_time_offset
	get_tree().call_group("invader", "activate")
	
	if row_idx == rows:
		_change_state(ACTIVE)
		add_child(defender)
		defender.position = Vector2(0, 272)
		print("ACTIVE")

func _physics_process(delta):
	if is_game_over():
		_change_state(END)
	
	if state == ACTIVE:
		if defender.dead == true:
			_change_state(INACTIVE)
		else:
			if time_counter == 0:
				var invader_dead = _move(delta)
				while invader_dead:
					invader_dead = _move(delta)
				time_counter = movement_delay
			else:
				time_counter = max(0, time_counter-1)
	elif state == INACTIVE:
		if defender.lives <= 0:
			_change_state(END)
		elif defender.can_respawn():
			defender.respawn(Vector2(0, 272))
			_change_state(ACTIVE)
	elif state == END:
		print("Game Over")
		set_physics_process(false)
		_game_over()
	

func _move(delta):
	if invader_idx == 0 and start_drop:
			drop = true
			start_drop = false
	elif invader_idx == 0 and drop:
		drop = false
	#
	
	var change_direction = drop
	var dead = invaders.get_child(invader_idx).dead
	if not dead:
		invaders.get_child(invader_idx).move(delta, drop, change_direction)
	
	if invader_idx == (num_invaders - 1) and drop:
		drop = false
	
	invader_idx = (invader_idx + 1) % num_invaders
	return dead

func start_drop():
	if not drop and not start_drop:
		start_drop = true

func speed_up(increase):
	pass #speed += 1

func is_game_over():
	if state == END:
		return true
	elif state == INIT or state == ACTIVATE or state == INACTIVE:
		return false
	elif state == ACTIVE:
		for invader in invaders.get_children():
			if not invader.dead:
				return false
	return true

func reset_invader_positions():
	get_tree().call_group("invader", "reset_position")

func _change_state(x):
	state = x
	print("state: " + str(state))

func _game_over():
	get_tree().root.get_children()[0].end_game()
	
