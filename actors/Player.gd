extends Actor
class_name Player

var dead := false
var lives := 3
var respawn_time := 300
var timer := 0

func _ready():
	$DeathSound.connect("finished", self, 'hide_and_disable')
	$CollisionShape2D.disabled = true
	speed = speed / 2
	get_tree().call_group("level", "update_ui_lives", lives)

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = min(speed, velocity.x + speed)
	elif Input.is_action_pressed("left"):
		velocity.x = max(-speed, velocity.x - speed)
		
	if Input.is_action_just_pressed("fire"):
		$Turrent.fire()
	
	move_and_collide(velocity*delta)
	velocity.x = lerp(velocity.x, 0.0, 0.2)

func disable_movement():
	set_physics_process(false)
	set_process(false)

func enable_movement():
	set_physics_process(true)
	set_process(true)

func _process(delta):
	if not dead and health <= 0:
		print(health)
		_die()
	if dead:
		if timer < respawn_time:
			timer += 1
			

func _die():
	# Clear all projectiles so that no kills are ever make after player death
	get_tree().call_group("projectile", "destroy_self")
	
	dead = true
	lives -= 1
	get_tree().call_group("level", "update_ui_lives", lives)
	$DeathSound.play()
	$AnimatedSprite.play("death")
	timer = 0
	set_physics_process(false)
	#hide_and_disable()
	
	# Need to call some end game logic at this point
#	print(get_parent().name)
#	get_tree().call_group("world", "end_game")
#	queue_free()

func hide_and_disable():
	#dead = true
	visible = false
	$CollisionShape2D.disabled = true
	#set_process(false)
	#set_physics_process(false)

func spawn(pos):
	reset_health()
	position = pos
	timer = 0
	dead = false
	visible = true
	$AnimatedSprite.play("default")
	$CollisionShape2D.disabled = false
	#set_process(true)
	set_physics_process(true)

func can_respawn():
	if timer == respawn_time and lives > 0:
		return true

