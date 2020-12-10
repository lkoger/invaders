extends KinematicBody2D
class_name BaracadeBlock

var health := 1

func _ready():
	pass

func damage(dmg: int):
	health -= dmg
	if health <= 0:
		queue_free()
