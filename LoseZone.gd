extends Area2D


func _ready():
	connect("body_entered", self, "end_game")

func end_game(body: Node):
	if body is Invader:
		get_tree().root.get_children()[0].end_game()
