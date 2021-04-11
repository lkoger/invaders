extends PopupMenu

var paused = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("pause") and not paused:
		get_tree().call_group("level", 'pause')
		paused = true
	elif Input.is_action_just_pressed("pause") and paused:
		hide()
		get_tree().call_group("level", 'unpause')
		paused = false
		

func _on_Button_pressed():
	hide()
	get_tree().call_group("level", 'unpause')


func _on_Restart_pressed():
	hide()
	get_tree().change_scene("res://world.tscn")
	get_tree().paused = false
