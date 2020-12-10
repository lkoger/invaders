extends KinematicBody2D
class_name Actor

export var health := 1
export var speed := 5
var velocity := Vector2(0.0,0.0)

func _ready():
	pass

func damage(dmg: int):
	health -= dmg
	print("Health: " + str(health))
