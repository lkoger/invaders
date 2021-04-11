extends Area2D
class_name Bullet

export var dmg := 1
var player_owned := true
var velocity := Vector2(0.0,0.0)
var turrent = null
var hit_something = false
onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	set_physics_process(false)
	connect("body_entered", self, "_on_body_entered")
	$LifeTime.connect("timeout", self, "_on_LifeTime_timeout")
	add_to_group("projectile")

func _physics_process(delta):
	position += velocity * delta

func fire(direction: Vector2, speed: float):
	velocity = direction * speed
	set_physics_process(true)
	$LifeTime.start()
	if player_owned:
		$FireSound.play()

func _on_body_entered(body: Node):
	if hit_something == false:
		if player_owned and body is Invader:
			hit_something = true
			body.damage(dmg)
			destroy_self()
		elif not player_owned and body is Player:
			hit_something = true
			body.damage(dmg)
			destroy_self()
		elif body is BaracadeBlock:
			hit_something = true
			var area_of_effect = $AreaOfEffect
			area_of_effect.set_global_position(body.global_position)
			var bodies = area_of_effect.get_inner_bodies()
			for x in bodies:
				if x.has_method('damage'):
					x.damage(dmg)
			
			bodies = area_of_effect.get_outer_bodies()
			for x in bodies:
				if x.has_method('damage'):
					var rand = rng.randf_range(0.0, 1.0)
					if rand <= 1.0:
						x.damage(dmg)
			body.damage(dmg)
			destroy_self()
		elif body is StaticBody2D:
			hit_something = true
			destroy_self()

func _on_LifeTime_timeout():
	destroy_self()

func destroy_self():
	if is_instance_valid(turrent) and turrent.has_method("set_can_fire"):
		turrent.set_can_fire(true)
	queue_free()

func add_turrent(node):
	turrent = node
