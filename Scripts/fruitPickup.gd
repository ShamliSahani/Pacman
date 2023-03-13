extends Node2D

var rnd = RandomNumberGenerator.new()


func _ready():
	collector()
	rnd.randomize()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and self.visible:
		print("fruit picked up")
		var tempScore
		match rnd.randi_range(1,7):
			1:
				tempScore = MyGlobals.score + 10
			2:
				tempScore = MyGlobals.score + 30
			3:
				tempScore = MyGlobals.score + 50
			4:
				tempScore = MyGlobals.score + 70
			5:
				tempScore = MyGlobals.score + 100
			6:
				tempScore = MyGlobals.score + 200
			7:
				tempScore = MyGlobals.score + 300
		MyGlobals.score = tempScore
		invisible()
		get_parent().get_parent().get_node("fruitSound").play()
		

func invisible():
	self.visible = false
	$Area2D.set_collision_layer_bit(0,0)
	
func collector():
	self.visible = true
	$Area2D.set_collision_layer_bit(0,1)
