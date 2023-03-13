extends KinematicBody2D

export (int) var speed = 200

var isMoving = 0
var lastDir = "left"
var _drag_status = 0
var velocity = Vector2()
var dir
var pos
var dragged = false
var finalPos

func move_player():
	if MyGlobals.gameOver == 0:
		move_and_slide(velocity)

func _physics_process(delta):
	#look_at(get_global_mouse_position())
	#checkDragStatus()
	pass
func _on_Area2D_body_entered(body):
	var group = body.get_groups()
	if group.has("cleaner"):
		MyGlobals.lifes = MyGlobals.lifes - 1
		print("life loss")
		get_parent().get_node("..").resetStage()

func _input(event):	
	if event.is_class("InputEventMouse"):
		if _drag_status == 0 and event.is_class("InputEventMouseButton") and event.button_index == BUTTON_LEFT and event.pressed:
			
			pos = get_global_mouse_position()
			_drag_status = 1
			#_drag_offset = self.position - (event.global_position)
		if _drag_status == 1 and event.is_class("InputEventMouseMotion"):
			
			var currentpos = get_global_mouse_position()
			_drag_status = 2
			print(currentpos.x - pos.x)
			var diff = currentpos - pos
			if diff.x > diff.y:
				if currentpos.x > pos.x:
					dir = "left"
					print("left")
				else:
					dir = "right"
					print("right")
					
			else:
				if currentpos.y > pos.y:
					dir = "up"
					print("up")
				else:
					dir = "down"
					print("down")
		if _drag_status == 2 and event.get_button_mask() != BUTTON_LEFT:
			_drag_status = 0      
		#if $topSprite.get_rect().has_point(to_local(event.position)):
			#call collision method here
	if event.is_class("InputEventMouse") and event.is_class("InputEventMouseButton")and event.button_index == BUTTON_LEFT and event.is_action_released("click"):
		#self.checkCollision()
		print()

func checkDragStatus():
	if (_drag_status==0 && self.dragged):
		
		self.dragged = false
	if _drag_status == 2:
		#finalPos = get_global_mouse_position() 
		#self.position = finalPos
		self.dragged=true
	if _drag_status == 1:
		#print(get_global_mouse_position(),",",pos) 
		var currentpos = get_global_mouse_position()
		if pos.x > currentpos.x:
			print("right")
		elif pos.x < currentpos.x:
			print("left")
		
		
