extends Actor
class_name MotherShip

var move_right := true
var score := 300


func _ready():
	add_to_group("mothership")
	pass
	
func _process(delta):
	if health <= 0:
		get_tree().call_group("level", "increment_score", score)
		_despawn()

func _physics_process(delta):
	if move_right:
		if $RightRayCast2D.is_colliding() and $RightRayCast2D.get_collider() is StaticBody2D:
			_despawn()
		velocity = Vector2(speed, 0.0)
	else:
		if $LeftRayCast2D.is_colliding() and $LeftRayCast2D.get_collider() is StaticBody2D:
			_despawn()
		velocity = Vector2(-speed, 0.0)
	
	move_and_collide(velocity*delta)

func _despawn():
	queue_free()
	get_tree().call_group("level", "start_mothership_timer")
	
