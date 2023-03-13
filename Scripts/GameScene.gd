extends TileMap

onready var coins = preload("res://Scenes/pickUp.tscn")
var usedcell
var coinloc := []
var i = 0
var Arraysize
func _ready():
	print(cell_size)
	usedcell = get_used_cells_by_id(1)
	Arraysize = usedcell.size()
	for i in Arraysize:
		coinloc.append(map_to_world(usedcell[i]) + cell_size/2)
		#print(map_to_world(usedcell[i]) + cell_size)
		var inst = coins.instance()
		inst.position = coinloc[i]
		self.add_child(inst)
		
	#for i in 19:
		
