extends Actor
class_name Player

var dead := false
var lives := 3
var respawn_time := 300
var timer := 0

func _ready():
	speed = speed / 2
	pass

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = min(speed, velocity.x + speed)
	elif Input.is_action_pressed("left"):
		velocity.x = max(-speed, velocity.x - speed)
		
	if Input.is_action_just_pressed("fire"):
		#$Turrent.can_fire = true
		$Turrent.fire()
	
	move_and_collide(velocity*delta)
	velocity.x = lerp(velocity.x, 0.0, 0.2)

func _process(delta):
	if not dead and health <= 0:
		print(health)
		_die()
	if dead:
		if timer < respawn_time:
			timer += 1
			

func _die():
	dead = true
	lives -= 1
	_hide_and_disable()
	
	# Need to call some end game logic at this point
#	print(get_parent().name)
#	get_tree().call_group("world", "end_game")
#	queue_free()

func _hide_and_disable():
	timer = 0
	dead = true
	visible = false
	$CollisionShape2D.disabled = true
	#set_process(false)
	set_physics_process(false)

func respawn(pos):
	reset_health()
	position = pos
	timer = 0
	dead = false
	visible = true
	$CollisionShape2D.disabled = false
	#set_process(true)
	set_physics_process(true)

func can_respawn():
	if timer == respawn_time and lives > 0:
		return true
