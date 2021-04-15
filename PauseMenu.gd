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
	get_tree().call_group("level", 'unpause')

func _on_Restart_pressed():
	hide()
	paused = false
	get_tree().paused = false
	get_tree().root.get_children()[0].end_game()

func _hide_and_disable(node: Button):
	node.hide()
	node.disabled = true

func _show_and_enable(node: Button):
	node.show()
	node.disabled = false
