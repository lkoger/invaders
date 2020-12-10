extends Actor
class_name Player

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		
	if Input.is_action_just_pressed("fire"):
		$Turrent.fire()
	
	move_and_collide(velocity)
	velocity.x = lerp(velocity.x, 0.0, 0.2)

func _process(delta):
	if health <= 0:
		_die()

func _die():
	# Need to call some end game logic at this point
	get_tree().call_group("level_controller", "end_game")
