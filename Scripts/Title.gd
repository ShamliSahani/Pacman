extends Node2D

onready var world1 = preload("res://Scenes/World.tscn")
onready var world2 = preload("res://Scenes/World2.tscn")
var rndnum = RandomNumberGenerator.new()
var num

func _ready():
	rndnum.randomize()
	num = rndnum.randi_range(1,2)
	print(num)
func _on_Button_pressed():
	if GameManager.num == 1:
		get_tree().change_scene("res://Scenes/World.tscn")
	else:
		get_tree().change_scene("res://Scenes/World2.tscn")



