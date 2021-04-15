extends Actor
class_name Invader

export var row := 1
export var direction := 1
export var drop_distance := 128 * 7
export var fire_chance := 1.0 / 18.0
onready var rng = RandomNumberGenerator.new()

var fire_delay := 30
var fire_delay_counter := fire_delay

var death_time := 15
var death_timer := death_time

var start_position := Vector2(0.0, 0.0)
var dead := false

var score := 10

func _ready():
	rng.randomize()
	add_to_group("invader")
	fire_delay = fire_delay + rng.randi_range(-15, 15)
	fire_delay_counter = fire_delay
	$BaracadeDestroyArea.connect("body_entered", self, "_destroy_baracade")
	set_process(false)
	set_physics_process(false)

func set_start_position(pos):
	start_position = pos

func reset_position():
	position = start_position

func activate():
	set_process(true)
	set_physics_process(true)

func set_score(val):
	score = val

func hide_and_disable():
	get_tree().call_group("invader_controller", "start_movement")
	dead = true
	visible = false
	$CollisionShape2D.disabled = true
	set_process(false)
	set_physics_process(false)
	get_tree().call_group("game", "increment_score", score)

func _process(delta):
	fire_delay_counter = max(0, fire_delay_counter-1)
	if health <= 0:
		if death_timer == death_time:
			die()
			death_timer -= 1
		elif death_timer > 0:
			death_timer -= 1
		else:
			hide_and_disable()

func _physics_process(delta):
	pass

func initial_drop(distance):
	position = Vector2(position.x, position.y + distance)

func move(delta, drop, change_direction, can_fire, just_drop):
	if dead:
		return
	
	if change_direction:
		change_direction()
	if not just_drop:
		_move(delta)
	if drop:
		drop(delta)
	
	if can_fire:
#		var colliding = $Turrent.is_colliding()
#		if not colliding:
		if fire_delay_counter == 0 and $Turrent.can_fire:
			fire_delay_counter = fire_delay
			if rng.randf_range(0.0, 1.0) <= fire_chance:
				$Turrent.fire()
	
	if direction > 0 and $RightRayCast2D.is_colliding() and $RightRayCast2D.get_collider() is StaticBody2D:
		announce_drop()
	elif direction < 0 and $LeftRayCast2D.is_colliding() and $LeftRayCast2D.get_collider() is StaticBody2D:
		announce_drop()
	

func announce_drop():
	get_tree().call_group("invader_controller", "start_drop")

func drop(delta):
	velocity = Vector2(0.0, drop_distance)
	move_and_collide(velocity * delta)

func change_direction():
	direction = -direction

func _move(delta):
	velocity = Vector2(speed*direction, 0.0)
	var collision = move_and_collide(velocity*delta)
	if collision:
		if collision.collider is BaracadeBlock:
			collision.collider.damage(1)
	var frame = $AnimatedSprite.get_frame()
	$AnimatedSprite.set_frame((frame + 1) % 2)

func is_turrent_colliding():
	return $Turrent.is_colliding()

func get_turrent_collider():
	return $Turrent.get_collider()

func set_sprite(animation_name):
	$AnimatedSprite.set_animation(animation_name)
	
func die():
	$DeathSound.play()
	$AnimatedSprite.set_animation("death")
	$AnimatedSprite.play()
	get_tree().call_group("invader_controller", "stop_movement")

func _destroy_baracade(body: Node):
	body.damage(1)

func shoot_blanks():
	$Turrent.set_shoot_blanks(true)
