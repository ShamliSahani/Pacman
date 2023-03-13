extends Node

var rndnum = RandomNumberGenerator.new()
var num
func _ready():
	rndnum.randomize()
	num = rndnum.randi_range(1,2)

