extends KinematicBody2D

var min_speed = 20
var max_speed = 60
var velocity = Vector2.ZERO
var player
var is_player = false
func _physics_process(delta):
	velocity = velocity + Vector2(50,52)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity.slide(collision.normal * delta)
		
	#velocity = move_and_slide(velocity)
	
#	velocity = Vector2.ZERO
#	if player != null:
#			velocity = position.direction_to(player.position) * rand_range(min_speed,max_speed)
#	else:
#		if position.y > 400 and position.y < 1910:
#			velocity = Vector2(rand_range(min_speed,max_speed),0)
#		else:
#			velocity = Vector2(rand_range(min_speed,max_speed),0) * -1
#	position += velocity * delta
#
#

func _on_Area2D_body_entered(body):
	var group = body.get_groups()
	if group.has("Player"):
		player = body
		

func _on_enemy_body_entered(body):
	MyGlobals.lifes = MyGlobals.lifes - 1
	is_player = true

