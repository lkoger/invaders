extends RayCast2D

export var bullet_speed := 600.0
var bullet = load("res://components/Bullet.tscn")
onready var root = get_tree().root.get_children()[0]
var can_fire := true

func _ready():
	pass

func fire():
	if can_fire:
		# Disallow firing another shot until the previous shot disappears
		can_fire = false
		
		# Subtract position from cast_to to get vector
		var direction = (to_global(cast_to) - global_position).normalized()
		var bullet_instance = bullet.instance()
		
		# Make child of root node so that projectile does not follow the actor
		# that fires it.
		root.add_child(bullet_instance)
		bullet_instance.add_turrent(self)
		
		bullet_instance.set_global_position(global_position)
		
		# Don't expect rotation to ever be important, but change anyway.
		bullet_instance.set_rotation_degrees(rotation_degrees)
		# If the turrent is not owned by the player, this will assume that it's
		# owned by an invader.
		bullet_instance.player_owned = (owner is Player)
		
		bullet_instance.fire(direction, bullet_speed)

func set_can_fire(value):
	can_fire = value
