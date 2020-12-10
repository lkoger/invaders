extends RayCast2D

export var bullet_speed := 300.0
var bullet = load("res://components/Bullet.tscn")
onready var root = get_tree().get_root()

func _ready():
	pass

func fire():
	# Subtract position from cast_to to get vector
	var direction = (to_global(cast_to) - global_position).normalized()
	var bullet_instance = bullet.instance()
	
	# Make child of root node so that projectile does not follow the actor
	# that fires it.
	root.add_child(bullet_instance)
	
	bullet_instance.set_global_position(global_position)
	
	# Don't expect rotation to ever be important, but change anyway.
	bullet_instance.set_rotation_degrees(rotation_degrees)
	# If the turrent is not owned by the player, this will assume that it's
	# owned by an invader.
	bullet_instance.player_owned = (owner is Player)
	
	bullet_instance.fire(direction, bullet_speed)
