extends PopupMenu


func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().call_group("level", 'pause')

func _on_Button_pressed():
	hide()
	get_tree().call_group("level", 'unpause')


func _on_Restart_pressed():
	hide()
	get_tree().change_scene("res://world.tscn")
	get_tree().paused = false
