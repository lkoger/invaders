extends Node2D

var invader = load("res://actors/Invader.tscn")
var rows := 5
var columns := 11
var time_offset := 1
var row_time_offset := 4
var time_counter := time_offset
var row_idx := 0
var col_idx := 0

enum {INIT, ACTIVATE}
var state = INIT

func _ready():
	add_to_group("level_controller")
	pause()

func _process(delta):
	pass

func pause():
	$PauseMenu.show()
	get_tree().paused = true

func unpause():
	$PauseMenu.hide()
	get_tree().paused = false
