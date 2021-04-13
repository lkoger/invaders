extends Control

var score := 0
var high_score := 0

func _ready():
	pass

func increment_score(inc):
	score += inc
	$Score.text = str(score)

func set_lives(lives):
	$Lives.text = str(lives)
	if lives == 3:
		$life_icons/life1.visible = true
		$life_icons/life2.visible = true
	elif lives == 2:
		$life_icons/life1.visible = true
		$life_icons/life2.visible = false
	elif lives < 2:
		$life_icons/life1.visible = false
		$life_icons/life2.visible = false

func set_high_score(val):
	high_score = val
	$HighScore.text = str(high_score)
	
func set_score(val):
	score = val
	$Score.text = str(score)
