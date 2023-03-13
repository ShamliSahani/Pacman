extends Node2D

var is_color = false

func _on_Area2D_body_entered(body):
	
	if body.is_in_group("Player") and is_color == false:
		var tempScore = MyGlobals.score + 10
		MyGlobals.score = tempScore
		var tempCount = MyGlobals.pickupCount + 1
		MyGlobals.pickupCount = tempCount
		get_parent().get_parent().get_parent().get_parent().get_node("chompSound").play()
		is_color = true
		self.modulate = Color.darkolivegreen
	if body.is_in_group("Ghost"):
		if is_color:
			self.modulate = Color.white
			is_color = false
