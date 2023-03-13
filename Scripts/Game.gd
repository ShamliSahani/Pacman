extends Node2D

var storedScore
const FILE_NAME = "user://game-data.json"
var player = {
	"hscore": 0,
}
var velocity = Vector2(0,0)
var speed = 120
var followerPosition
var followerposition2
func _ready():
	followerPosition = Vector2(336.54,557.26)
	followerposition2 = Vector2(172,144)
	fruitSpawned = 0
	
	
	MyGlobals.powerUpActive = 0
	MyGlobals.pickupCount = 0
	MyGlobals.score = 0
	MyGlobals.lifes = 3
	
	#set up game over 
	MyGlobals.gameOver = 0
	get_node("GameOverText").visible = false
	#hide fruit until spawned
	var pickUps = get_tree().get_nodes_in_group("fruit")
	print("pickups",pickUps)
	for i in pickUps:
		i.visible = true
		#i.get_node("pos/Area2D").set_collision_layer_bit(0,0)
		#i.get_node("pos/Area2D").set_collision_mask_bit(0,0)
	
	
	#save()
	loadf()
	MyGlobals.savedHighScore = player.hscore
	print(MyGlobals.savedHighScore)
	
	get_node("HighScore/HighScoreNumber").text = str(MyGlobals.savedHighScore)
	
	#displays first score
	get_node("Score/ScoreNumber").text = str(MyGlobals.score)
	
	#displays life
	displayLife()
	
	#displays level fruit icon 
	displayLevel()
	
	newStage()
	
	pass # Replace with function body.

var fruitSpawned = 0

func spawnFruit():
	print("spawning fruit")
	var pickUps = get_tree().get_nodes_in_group("fruit")
	for i in pickUps:
		i.visible = true
		i.get_node("Sprite").visible = true
		#i.get_node("pos/Area2D").set_collision_layer_bit(0,1)
		#i.get_node("pos/Area2D").set_collision_mask_bit(0,1)

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(player))
	file.close()

func loadf():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			player = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

#calls when a pickUp is touched, checks if all pick ups are not visable to win
func checkWin():
	var hasWin = 1
	var pickUps = get_tree().get_nodes_in_group("pickUp")
	for i in pickUps:
		if(i.visible == true):
			hasWin = 0
	if(hasWin == 1):
		var tempLevel = MyGlobals.level + 1
		MyGlobals.level = tempLevel
		print("stage win")
		resetStage2()
	pass

#calls on new game, refreshes the pickups and level++
func newStage():
	#remask reshow pickups
	var pickUps = get_tree().get_nodes_in_group("pickUp")
	for i in pickUps:
		i.visible = true
		#i.get_node("pos/Area2D").set_collision_layer_bit(0,1)
		#i.get_node("pos/Area2D").set_collision_mask_bit(0,1)
	#get_node("GhostSpawn").position

#called when stage won
func resetStage2():
		#reposition Player
		var playerLoc = get_node("pos/PlayerSpawn").position
		get_node("pos/Player").position = playerLoc
		get_node("pos/Player").lastDir = ""
		
		#repositions ghosts
		var ghostLoc = get_node("pos/GhostSpawn").position
		var ghosts = get_tree().get_nodes_in_group("Ghost")
		for i in ghosts:
			i.position = ghostLoc
		#get_node("GhostSpawn").position
		
		#refresh pickUps twice, sloppy fix for spawning missing pickup bug
		newStage()
		$PickupTimer.start()


#called when touched by ghost, reset positions if have life
func resetStage():
	#remove life
	var tempLife = MyGlobals.lifes - 1
	if (tempLife < 0):
		MyGlobals.gameOver = 1
		get_node("GameOverText").visible = true
		get_node("GameOverText/ReplayButton").grab_focus()
		
		if(MyGlobals.score > MyGlobals.savedHighScore):
			print("New high score!")
			player.hscore = MyGlobals.score
			save()
		else:
			print("No high score.")
		
	else:
		MyGlobals.lifes = tempLife
		displayLife()
		
		#repositions ghosts
		var ghostLoc = get_node("pos/GhostSpawn").position
		var ghosts = get_tree().get_nodes_in_group("Ghost")
		for i in ghosts:
			i.position = ghostLoc
		#get_node("GhostSpawn").position
		
		
		#reposition Player
		var playerLoc = get_node("pos/PlayerSpawn").position
		get_node("pos/Player").position = playerLoc
		get_node("pos/Player").lastDir = ""
		
		#refresh pickUps
		#newStage()

func displayLevel():
	get_node("pos/fruit0").visible = false
	get_node("pos/fruit1").visible = false
	get_node("pos/fruit2").visible = false
	get_node("pos/fruit3").visible = false
	get_node("pos/fruit4").visible = false
	get_node("pos/fruit5").visible = false
	get_node("pos/fruit6").visible = false
	match MyGlobals.level:
		0:
			get_node("pos/fruit0").visible = false
			get_node("pos/fruit1").visible = false
			get_node("pos/fruit2").visible = false
			get_node("pos/fruit3").visible = false
			get_node("pos/fruit4").visible = false
			get_node("pos/fruit5").visible = false
			get_node("pos/fruit6").visible = false
#		1:
#			get_node("pos/fruit0").visible = true
#		2:
#			get_node("pos/fruit0").visible = true
#			get_node("pos/fruit1").visible = true
#		3:
#			get_node("pos/fruit0").visible = true
#			get_node("pos/fruit1").visible = true
#			get_node("pos/fruit2").visible = true
#		4:
#			get_node("pos/fruit0").visible = true
#			get_node("pos/fruit1").visible = true
#			get_node("pos/fruit2").visible = true
#			get_node("pos/fruit3").visible = true
#		5:
#			get_node("pos/fruit0").visible = true
#			get_node("pos/fruit1").visible = true
#			get_node("pos/fruit2").visible = true
#			get_node("pos/fruit3").visible = true
#			get_node("pos/fruit4").visible = true
#		6:
#			get_node("pos/fruit0").visible = true
#			get_node("pos/fruit1").visible = true
#			get_node("pos/fruit2").visible = true
#			get_node("pos/fruit3").visible = true
#			get_node("pos/fruit4").visible = true
#			get_node("pos/fruit5").visible = true
#		7:
#			get_node("pos/fruit0").visible = true
#			get_node("pos/fruit1").visible = true
#			get_node("pos/fruit2").visible = true
#			get_node("pos/fruit3").visible = true
#			get_node("pos/fruit4").visible = true
#			get_node("pos/fruit5").visible = true
#			get_node("pos/fruit6").visible = true
#		_:
#			get_node("pos/fruit0").visible = true
#			get_node("pos/fruit1").visible = true
#			get_node("pos/fruit2").visible = true
#			get_node("pos/fruit3").visible = true
#			get_node("pos/fruit4").visible = true
#			get_node("pos/fruit5").visible = true
#			get_node("pos/fruit6").visible = true

func displayLife():
	get_node("pos/life0").visible = false
	get_node("pos/life1").visible = false
	get_node("pos/life2").visible = false
	get_node("pos/life3").visible = false
	get_node("pos/life4").visible = false
	match MyGlobals.lifes:
		0:
			get_node("pos/life0").visible = false
			get_node("pos/life1").visible = false
			get_node("pos/life2").visible = false
			get_node("pos/life3").visible = false
			get_node("pos/life4").visible = false
		1:
			get_node("pos/life0").visible = true
		2:
			get_node("pos/life0").visible = true
			get_node("pos/life1").visible = true
		3:
			get_node("pos/life0").visible = true
			get_node("pos/life1").visible = true
			get_node("pos/life2").visible = true
		4:
			get_node("pos/life0").visible = true
			get_node("pos/life1").visible = true
			get_node("pos/life2").visible = true
			get_node("pos/life3").visible = true
		5:
			get_node("pos/life0").visible = true
			get_node("pos/life1").visible = true
			get_node("pos/life2").visible = true
			get_node("pos/life3").visible = true
			get_node("pos/life4").visible = true

var extralifeReward1 = 0
var extralifeReward2 = 0
var extralifeReward3 = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	if $Sprite/TouchScreenButton.direction == "left":
		$pos/Player.velocity.x -= 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	elif $Sprite/TouchScreenButton.direction == "right":
		$pos/Player.velocity.x += 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	elif $Sprite/TouchScreenButton.direction == "up":
		$pos/Player.velocity.y -= 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	elif $Sprite/TouchScreenButton.direction == "down":
		$pos/Player.velocity.y += 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	if(MyGlobals.score >= 1000 && MyGlobals.score < 1500 && extralifeReward1 == 0):
		extralifeReward1 = 1
		var tempLife = MyGlobals.lifes + 1
		MyGlobals.lifes = tempLife
		displayLife()
		print("rewarding first 1up")
	elif(MyGlobals.score >= 1500 && MyGlobals.score < 2000 && extralifeReward2 == 0):
		extralifeReward2 = 1
		var tempLife = MyGlobals.lifes + 1
		MyGlobals.lifes = tempLife
		displayLife()
		print("rewarding second 1up")
	elif(MyGlobals.score >= 2000 && extralifeReward3 == 0):
		extralifeReward3 = 1
		var tempLife = MyGlobals.lifes + 1
		MyGlobals.lifes = tempLife
		displayLife()
		print("rewarding second 1up")
	if(MyGlobals.pickupCount == 50 && fruitSpawned == 0):
		fruitSpawned = 1
		MyGlobals.pickupCount = 0
		spawnFruit()
	get_node("Score/ScoreNumber").text = str(MyGlobals.score)
	#get_node("HighScore/HighScoreNumber").text = str(MyGlobals.score)
	
	var pos = $pos/Player.position
	var loc = $pos/Nav/TileMap.world_to_map(pos)
	var cell = $pos/Nav/TileMap.get_cell(loc.x,loc.y)
	if cell != -1:
		$pos/Nav/TileMap.set_cell(loc.x,loc.y,3)

	else:
		print($pos/Nav/TileMap.tile_set.tile_get_name(cell))
	
	
	var ghostpos = $pos/Ghost.position
	var ghostloc = $pos/Nav/TileMap.world_to_map(ghostpos)
	var ghostcell = $pos/Nav/TileMap.get_cell(ghostloc.x,ghostloc.y)
	if ghostcell != 17:
		$pos/Nav/TileMap.set_cell(ghostloc.x,ghostloc.y,17)
		
	var ghostpos2 = $pos/Ghost2.position
	var ghostloc2 = $pos/Nav/TileMap.world_to_map(ghostpos2)
	var ghostcell2 = $pos/Nav/TileMap.get_cell(ghostloc2.x,ghostloc2.y)
	if ghostcell2 != 17:
		$pos/Nav/TileMap.set_cell(ghostloc2.x,ghostloc2.y,17)
	
	var ghostpos3 = $pos/Ghost3.position
	var ghostloc3 = $pos/Nav/TileMap.world_to_map(ghostpos3)
	var ghostcell3 = $pos/Nav/TileMap.get_cell(ghostloc3.x,ghostloc3.y)
	if ghostcell3 != 17:
		$pos/Nav/TileMap.set_cell(ghostloc3.x,ghostloc3.y,17)
		
	var ghostpos4 = $pos/Ghost4.position
	var ghostloc4 = $pos/Nav/TileMap.world_to_map(ghostpos4)
	var ghostcell4 = $pos/Nav/TileMap.get_cell(ghostloc4.x,ghostloc4.y)
	if ghostcell4 != 17:
		$pos/Nav/TileMap.set_cell(ghostloc4.x,ghostloc4.y,17)
		
	var pf = $pos/Nav/KinematicBody2D.position
	var pfloc = $pos/Nav/TileMap.world_to_map(pf)
	var pfcell = $pos/Nav/TileMap.get_cell(pfloc.x,pfloc.y)
	if pfcell != 17:
		$pos/Nav/TileMap.set_cell(pfloc.x,pfloc.y,17)
		
	var pf2 = $pos/Nav/KinematicBody2D2.position
	var pfloc2 = $pos/Nav/TileMap.world_to_map(pf2)
	var pfcell2 = $pos/Nav/TileMap.get_cell(pfloc2.x,pfloc2.y)
	if pfcell2 != 17:
		$pos/Nav/TileMap.set_cell(pfloc2.x,pfloc2.y,17)

func _on_GhostCage_body_entered(body):
	if body.is_in_group("Ghost"):
		body.isCaged = true
		#var tempScore = MyGlobals.score + 50
		#MyGlobals.score = tempScore
		#queue_free()
	pass # Replace with function body.


func _on_GhostCage_body_exited(body):
	if body.is_in_group("Ghost"):
		body.isCaged = false
	#var tempScore = MyGlobals.score + 50
	#MyGlobals.score = tempScore
	#queue_free()
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.is_in_group("Ghost"):
		body.moveUp()
	pass # Replace with function body.


func _on_ReplayButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")
	pass # Replace with function body.

#resume game when stage is setup
func _on_PickupTimer_timeout():
	newStage()
	pass # Replace with function body.

func setPowerUp():
	#repositions ghosts
	#var ghostLoc = get_node("GhostSpawn").position
	var ghosts = get_tree().get_nodes_in_group("Ghost")
	for i in ghosts:
		i.set_modulate(Color(0,0,1))
	#get_node("GhostSpawn").position

func unsetPowerUp():
	var ghosts = get_tree().get_nodes_in_group("Ghost")
	for i in ghosts:
		i.set_modulate(Color(1,1,1))

func _on_PowerupTimer_timeout():
	MyGlobals.powerUpActive = 0
	MyGlobals.eatCombo = 0
	unsetPowerUp()
	pass # Replace with function body.


func _on_leftTeleport_body_entered(body):
	#reposition Player
	if body.is_in_group("Ghost") || body.is_in_group("Player"):
		var rightLoc = get_node("pos/rightTeleportSpot").position
		body.position = rightLoc
	#get_node("Player").lastDir = ""
	pass # Replace with function body.


func _on_rightTeleport_body_entered(body):
	if body.is_in_group("Ghost") || body.is_in_group("Player"):
		var leftLoc = get_node("pos/leftTeleportSpot").position
		body.position = leftLoc
	pass # Replace with function body.

#
#
#func _on_enemy_body_entered(body):
#	var group = body.get_groups()
#	if group.has("Player"):
#		player = body
#		MyGlobals.lifes = MyGlobals.lifes - 1
#		resetStage()


func Player_Follower(body):
	if body.is_in_group("Player") && MyGlobals.gameOver == 0:
		print("player hit")
		
		resetStage()
		#get_parent().get_parent().resetStage()
		#get_node("..").resetStage()
		$deathSound.play()
		
		$pos/Nav/KinematicBody2D.position = followerPosition
		$pos/Player.position = $pos/PlayerSpawn.position
		


func player_hit():
	$pos/Player.position = $pos/PlayerSpawn.position


func player_follower2(body):
	if body.is_in_group("Player") && MyGlobals.gameOver == 0:
		print("player hit")
		
		resetStage()
		#get_parent().get_parent().resetStage()
		#get_node("..").resetStage()
		$deathSound.play()
		
		$pos/Nav/KinematicBody2D2.position = followerposition2
		$pos/Player.position = $pos/PlayerSpawn.position
	


