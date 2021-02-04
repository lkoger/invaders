extends Area2D

export var dmg := 1
var player_owned := true
var velocity := Vector2(0.0,0.0)
var turrent = null

func _ready():
	set_physics_process(false)
	connect("body_entered", self, "_on_body_entered")
	$LifeTime.connect("timeout", self, "_on_LifeTime_timeout")

func _physics_process(delta):
	position += velocity * delta

func fire(direction: Vector2, speed: float):
	velocity = direction * speed
	set_physics_process(true)
	$LifeTime.start()

func _on_body_entered(body: Node):
	if player_owned and body is Invader:
		body.damage(dmg)
		destroy_self()
	elif not player_owned and body is Player:
		body.damage(dmg)
		destroy_self()
	elif body is BaracadeBlock:
		body.damage(dmg)
		destroy_self()
	elif body is StaticBody2D:
		destroy_self()

func _on_LifeTime_timeout():
	destroy_self()

func destroy_self():
	if is_instance_valid(turrent) and turrent.has_method("set_can_fire"):
		turrent.set_can_fire(true)
	queue_free()

func add_turrent(node):
	turrent = node
