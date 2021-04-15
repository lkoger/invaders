extends Control

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("pause") and not visible:
		get_tree().call_group("game", 'pause')
	elif Input.is_action_just_pressed("pause") and visible:
		_on_Start_pressed()
		
func end_game():
	_hide_and_disable($Resume)
	_show_and_enable($Start)
	$Restart.disabled = true
	#get_tree().call_group("level", 'pause')
	#paused = true

func _on_Start_pressed():
	hide()
	_hide_and_disable($Start)
	_show_and_enable($Resume)
	$Restart.disabled = false
	get_tree().call_group("game", 'unpause')

func _on_Restart_pressed():
	hide()
	get_tree().paused = false
	get_tree().root.get_children()[0].end_game()

func _hide_and_disable(node: Button):
	node.hide()
	node.disabled = true

func _show_and_enable(node: Button):
	node.show()
	node.disabled = false
