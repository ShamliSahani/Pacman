extends TouchScreenButton

var radius = Vector2(60, 60)
var boundary = 50

var ongoing_drag = -1

var return_accel = 20

var threshold = 10
var direction
var startingpos
func _ready():
	startingpos = position
	print(position)


func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0,0) - radius) - position
		position += pos_difference * return_accel * delta
		
	var diff = position - startingpos
	if diff.x > diff.y:
		if position.x > startingpos.x:
			#print("right")
			direction = "right"
		elif position.x < startingpos.x:
			#print("up")
			direction = "up"
	elif diff.x < diff.y:
		if position.y > startingpos.y:
			#print("down")
			direction = "down"
		elif position.y < startingpos.y:
			#print("left")
			direction = "left"

func get_button_pos():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_centre = (event.position - get_parent().global_position).length()

		if event_dist_from_centre <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)

			if get_button_pos().length() > boundary:
				set_position( get_button_pos().normalized() * boundary - radius)

			ongoing_drag = event.get_index()

	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1

func get_value():
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()
	return Vector2(0, 0)
