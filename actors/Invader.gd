extends Actor
class_name Invader

export var direction := 1
export var drop_distance := 32
export var fire_chance := 0.10
onready var rng = RandomNumberGenerator.new()

var fire_delay := 60
var fire_delay_counter := fire_delay

var dropping := false

func _ready():
	rng.randomize()
	add_to_group("invaders")
	fire_delay = fire_delay + rng.randi_range(-15, 15)
	fire_delay_counter = fire_delay

func _process(delta):
	fire_delay_counter = max(0, fire_delay_counter-1)
	if health <= 0:
		queue_free()

func _physics_process(delta):
	var colliding = $Turrent.is_colliding()
	if not colliding:
		if fire_delay_counter == 0:
			fire_delay_counter = fire_delay
			if rng.randf_range(0.0, 1.0) <= fire_chance:
				$Turrent.fire()
	
	if direction > 0 and $RightRayCast2D.is_colliding() and $RightRayCast2D.get_collider() is StaticBody2D:
		#start_drop()
		announce_drop()
	elif direction < 0 and $LeftRayCast2D.is_colliding() and $LeftRayCast2D.get_collider() is StaticBody2D:
		#start_drop()
		announce_drop()
	if not dropping:
		_move()

func start_drop():
	if not dropping:
		change_direction()
		$timers/DropTimer.start()
		dropping = true

func announce_drop():
	get_tree().call_group("invaders", "start_drop")

func drop():
	$timers/StarAfterDropTimer.start()
	velocity = Vector2(0.0, drop_distance)
	move_and_collide(velocity)

func change_direction():
	direction = -direction

func _move():
	velocity = Vector2(speed*direction, 0.0)
	move_and_collide(velocity)

func _on_DropTimer_timeout():
	drop()

func _on_StarAfterDropTimer_timeout():
	dropping = false
