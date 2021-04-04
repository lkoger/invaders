extends Actor
class_name Invader

export var row := 1
export var direction := 1
export var drop_distance := 128 * 4
export var fire_chance := 1.0 / 5.5
onready var rng = RandomNumberGenerator.new()

var fire_delay := 30
var fire_delay_counter := fire_delay

var start_position := Vector2(0.0, 0.0)
var dead := false

func _ready():
	rng.randomize()
	add_to_group("invader")
	fire_delay = fire_delay + rng.randi_range(-15, 15)
	fire_delay_counter = fire_delay
	set_process(false)
	set_physics_process(false)

func set_start_position(pos):
	start_position = pos

func reset_position():
	position = start_position

func activate():
	set_process(true)
	set_physics_process(true)

func hide_and_disable():
	dead = true
	visible = false
	$CollisionShape2D.disabled = true
	set_process(false)
	set_physics_process(false)

func _process(delta):
	fire_delay_counter = max(0, fire_delay_counter-1)
	if health <= 0:
		hide_and_disable()

func _physics_process(delta):
	pass

func move(delta, drop, change_direction):
	if dead:
		return
	
	if change_direction:
		change_direction()
	_move(delta)
	if drop:
		drop(delta)
	
	var colliding = $Turrent.is_colliding()
	if not colliding:
		if fire_delay_counter == 0 and $Turrent.can_fire:
			fire_delay_counter = fire_delay
			if rng.randf_range(0.0, 1.0) <= fire_chance:
				$Turrent.fire()
	
	if direction > 0 and $RightRayCast2D.is_colliding() and $RightRayCast2D.get_collider() is StaticBody2D:
		print($RightRayCast2D.get_collider().get_class())
		announce_drop()
	elif direction < 0 and $LeftRayCast2D.is_colliding() and $LeftRayCast2D.get_collider() is StaticBody2D:
		print($LeftRayCast2D.get_collider().get_class())
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
	move_and_collide(velocity*delta)
