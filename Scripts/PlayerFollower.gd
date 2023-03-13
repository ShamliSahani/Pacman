extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 60
var path: Array = []
var levelNavigation: Navigation2D = null
var player = null


onready var line2d = $Line2D



func _ready():
	yield(get_tree(),"idle_frame")
	var tree = get_tree()
	if tree.has_group("Nav"):
		print("nav")
		levelNavigation = tree.get_nodes_in_group("Nav")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if player and levelNavigation:
		generate_path()
		navigate()
		
		
	move()
	
	


func navigate():	# Define the next position to go to
	if path.size() > 0:
		velocity = position.direction_to(path[1]) * speed
		#print(global_position)
		if global_position == path[0]:
			path.pop_front()
func generate_path():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(position,player.position,false)
		line2d.points = path
		
func move():
	if MyGlobals.gameOver == 0:
		velocity  = move_and_slide(velocity)






