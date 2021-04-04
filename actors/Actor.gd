extends KinematicBody2D
class_name Actor

export var starting_health := 1
var health := starting_health

export var speed := 5
var velocity := Vector2(0.0,0.0)

func _ready():
	pass

func damage(dmg: int):
	health -= dmg

func reset_health():
	health = starting_health
