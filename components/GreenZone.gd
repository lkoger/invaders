extends Area2D


func _ready():
	connect("body_entered", self, "_disable_turrents")
	pass

func _disable_turrents(body: Node):
	if body is Invader:
		body.shoot_blanks()
