extends Node2D

var level = load("res://levels/Level1.tscn")
var level_instance = null

var high_score := 0

func _ready():
	add_to_group("world")
	_instantiate_level()

func _instantiate_level():
	if not is_instance_valid(level_instance):
		level_instance = level.instance()
		add_child(level_instance)

func new_round():
	level_instance.new_round(false)

func end_game():
	high_score = max(level_instance.get_node('GameInfo').score, high_score)
	#get_tree().reload_current_scene()
	level_instance.get_node('GameInfo').set_high_score(high_score)
	level_instance.get_node('GameInfo').set_score(0)
	level_instance.new_round(true)
