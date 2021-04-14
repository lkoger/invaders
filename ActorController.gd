extends Node2D

var invader = load("res://actors/Invader.tscn")
onready var defender = load("res://actors/Player.tscn").instance()
var defender_spawn_pos = Vector2(0, 190)
var rows := 5
var columns := 11
var time_offset := 1
var row_time_offset := 4
var time_counter := time_offset
var row_idx := 0
var col_idx := 0
var invader_idx := 0
var num_invaders := rows * columns
var col_offset := 44
var row_offset := 40
#var lives := 3

var initial_drop_distance := 15
var drop_time := 15
var drop_timer := 0
var num_drops := 0
var round_number := 0

export var movement_delay := 0
var speed := 1

var sounds_per_iteration := 1
var sound_iterations := 0

enum {INIT, ACTIVATE, ACTIVE, INACTIVE, END, DROP}
var state = INIT

var start_drop := false
var drop := false

var game_over := false

onready var invaders = $invaders

func _ready():
	add_to_group("invader_controller")
	# Set position of the defender here and then hide.
	# Otherwise there is time before the game starts where
	# the invaders collide with the invader and cause issues.
	defender.spawn(defender_spawn_pos)
	defender.hide_and_disable()
	add_child(defender)

func _process(delta):
	if state == INIT:
		_init_invaders(delta)
	elif state == ACTIVATE:
		_activate(delta)
	
	if not state == ACTIVE:
		time_counter = max(0, time_counter-1)

func new_round(new_game):
	if new_game:
		round_number = 0
		defender.lives = 3
		get_tree().call_group("level", "update_ui_lives", defender.lives)
	else:
		round_number = (round_number + 1) % 11
	
	defender.hide_and_disable()
	for invader in invaders.get_children():
		invader.queue_free()
	col_idx = 0
	row_idx = 0
	invader_idx = 0
	state = INIT
	game_over = false
	#set_physics_process(true)

func _init_invaders(delta):
	if row_idx < rows and time_counter == 0:
		var invader_instance = invader.instance()
		invader_instance.row = row_idx
		invaders.add_child(invader_instance)
		invader_instance.position = Vector2((col_idx*col_offset) - (col_offset*columns*0.5), -row_idx*row_offset)
		if row_idx < 2:
			invader_instance.set_score(10)
			invader_instance.set_sprite('bottom_row')
		elif row_idx < 4:
			invader_instance.set_score(20)
			invader_instance.set_sprite('middle_row')
		else:
			invader_instance.set_score(30)
			invader_instance.set_sprite('top_row')
		#invader_instance.set_sprite('godot')

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

func _drop(delta):
	if drop_timer == drop_time:
		drop_timer = 0
		if num_drops >= round_number:
			num_drops = 0
			drop_timer = 0
			_change_state(ACTIVE)
			#defender.spawn(defender_spawn_pos)
			defender.enable_movement()
		else:
			$MoveSound.play()
			for invader in invaders.get_children():
				#invader.move(delta, true, false, false, true)
				invader.initial_drop(initial_drop_distance)
			num_drops += 1
	else:
		drop_timer += 1

func _activate(delta):
	row_idx += 1
	time_counter = row_time_offset
	get_tree().call_group("invader", "activate")
	
	if row_idx == rows:
		#_change_state(ACTIVE)
#		add_child(defender)
#		defender.position = Vector2(0, 272)
		defender.spawn(defender_spawn_pos)
		defender.disable_movement()
		_change_state(DROP)
		print("DROP")

func _physics_process(delta):
	if is_game_over():
		_change_state(END)
	
	if state == ACTIVE:
		if defender.dead == true:
			_change_state(INACTIVE)
			get_tree().call_group("mothership", "stop_movement")
		else:
			if time_counter == 0:
				var invader_dead = _move(delta)
				while invader_dead:
					invader_dead = _move(delta)
				time_counter = movement_delay
			else:
				time_counter = max(0, time_counter-1)
	elif state == INACTIVE:
		if defender.lives <= 0 and defender.timer == defender.respawn_time:
			_change_state(END)
		elif defender.can_respawn():
			defender.spawn(defender_spawn_pos)
			_change_state(ACTIVE)
			get_tree().call_group("mothership", "start_movement")
		else:
			get_tree().call_group("mothership", "stop_movement")
	elif state == END:
		_game_over()
	elif state == DROP:
		_drop(delta)
	

func _move(delta):
	if invader_idx == 0 and start_drop:
			drop = true
			start_drop = false
	elif invader_idx == 0 and drop:
		drop = false
	
	if invader_idx == 0:
		if sound_iterations == 0 and not $MoveSound.is_playing():
			$MoveSound.play()
		sound_iterations = (sound_iterations + 1) % sounds_per_iteration
	
	var change_direction = drop
	var dead = invaders.get_child(invader_idx).dead
	if not dead:
		var child = invaders.get_child(invader_idx)
		var can_fire = true
		if child.is_turrent_colliding():
			var collider = child.get_turrent_collider()
			if collider is Invader:
				can_fire = false
		child.move(delta, drop, change_direction, can_fire, false)
	
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
	elif state == DROP:
		return false
	return true

func reset_invader_positions():
	get_tree().call_group("invader", "reset_position")

func _change_state(x):
	state = x
	print("state: " + str(state))

func _game_over():
	if game_over == false:
		game_over = true
		#set_physics_process(false)
		if defender.lives > 0:
			print("New Round")
			get_tree().root.get_children()[0].new_round()
		else:
			print("End Game")
			get_tree().root.get_children()[0].end_game()

func stop_movement():
	set_physics_process(false)

func start_movement():
	set_physics_process(true)
