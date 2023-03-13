extends Position2D

var speed = 150
var nav = null setget set_nav
var path = []
var goal = Vector2()

func _ready():
	pass

func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	path = nav.get_simple_path(position, goal, false)
	if path.size() == 0:
		queue_free()

func _fixed_process(delta):
	if path.size() > 1:
		var d = position.distance_to(path[0])
		if d > 2:
			position += position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)
