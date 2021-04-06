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

func set_high_score(val):
	high_score = val
	$HighScore.text = str(high_score)
	
func set_score(val):
	score = val
	$Score.text = str(score)
