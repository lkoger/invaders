extends Area2D

export var dmg := 10
var player_owned := true
var velocity := Vector2(0.0,0.0)

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
		queue_free()
	elif not player_owned and body is Player:
		body.damage(dmg)
		queue_free()
	elif body is BaracadeBlock:
		body.damage(dmg)
		queue_free()
	
	

func _on_LifeTime_timeout():
	queue_free()
