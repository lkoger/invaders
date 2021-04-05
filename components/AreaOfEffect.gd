extends Node2D


func _ready():
	pass

func get_inner_bodies():
	return $InnerArea.get_overlapping_bodies()

func get_outer_bodies():
	return $OuterArea.get_overlapping_bodies()
