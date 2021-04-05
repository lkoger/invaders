extends RayCast2D

export var bullet_speed := 600.0
export var missle_speed := 100.0
var bullet = load("res://components/Bullet.tscn")
var missle = load("res://components/Missle.tscn")
onready var root = get_tree().root.get_children()[0]
var can_fire := true
onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func fire():
	if can_fire:
		# Disallow firing another shot until the previous shot disappears
		can_fire = false
		var player_owned = (owner is Player)
		
		# Subtract position from cast_to to get vector
		var direction = (to_global(cast_to) - global_position).normalized()
		var projectile = _get_projectile()
		
		# Make child of root node so that projectile does not follow the actor
		# that fires it.
		root.add_child(projectile)
		projectile.add_turrent(self)
		
		projectile.set_global_position(global_position)
		
		# Don't expect rotation to ever be important, but change anyway.
		projectile.set_global_rotation_degrees(global_rotation_degrees)
		if projectile is Bullet:
			# If the turrent is not owned by the player, this will assume that it's
			# owned by an invader.
			projectile.player_owned = (owner is Player)
			projectile.fire(direction, bullet_speed)
		elif projectile is Missle:
			projectile.fire(direction, missle_speed)

func set_can_fire(value):
	can_fire = value

func _get_projectile():
	# If the turrent is player owned, only ever fire bullets. Missle are
	# reserved for invaders.
	var bullet_chance = 0.0
	if owner is Player:
		bullet_chance = 1.0
		
	if rng.randf_range(0.0, 1.0) <= bullet_chance:
		return bullet.instance()
	else:
		return missle.instance()
