extends Node2D



func _on_ReplayButton_pressed():
	if GameManager.num == 1:
		get_tree().change_scene("res://Scenes/World.tscn")
	else:
		get_tree().change_scene("res://Scenes/World2.tscn")
