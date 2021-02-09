extends Node2D

var invader = load("res://actors/Invader.tscn")
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

enum {INIT, ACTIVATE, ACTIVE, END}
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
		state = ACTIVATE
		row_idx = 0
		col_idx = 0


func _activate(delta):
	if row_idx < rows and time_counter == 0:
		print("in activate")
		# Needs to just iterate through each child at some point
		# instead of the whole row
		get_tree().call_group("invader", "activate")
		row_idx += 1
		time_counter = row_time_offset
	if row_idx == rows:
		state = ACTIVE
		print("ACTIVE")

func _physics_process(delta):
	if is_game_over():
		state = END
	
	if state == ACTIVE:
		if time_counter == 0:
			var invader_dead = _move(delta)
			while invader_dead:
				invader_dead = _move(delta)
			time_counter = movement_delay
		else:
			time_counter = max(0, time_counter-1)
	elif state == END:
		print("Game Over")
		set_physics_process(false)

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
	elif state == INIT or state == ACTIVATE:
		return false
	elif state == ACTIVE:
		for invader in invaders.get_children():
			if not invader.dead:
				return false
	return true
