extends Node2D

var fruitpos = [Vector2(274,150),Vector2(561,346),Vector2(685,50),Vector2(77,404),Vector2(357,624),Vector2(403,689)]
var followerpos = [Vector2(344,148),Vector2(686,288),Vector2(300,690),Vector2(41,363)]
var ghostpos = [Vector2(409,272),Vector2(54,144),Vector2(688,399),Vector2(357,687)]
var playerpos = [Vector2(626,625),Vector2(559,380),Vector2(378,504),Vector2(372,625)]
var speed = 120
var rndnum = RandomNumberGenerator.new()
var extralifeReward1 = 0
var extralifeReward2 = 0
var extralifeReward3 = 0
var fruitSpawned = 0

func _ready():
	displayLife()
	$pos/fruitPickUp.position = fruitpos[rndnum.randi_range(0,5)]
	$Gameover.visible = false
	
	followerpos.shuffle()
	rndnum.randomize()
	positionAllocator()
	MyGlobals.powerUpActive = 0
	MyGlobals.pickupCount = 0
	MyGlobals.score = 0
	MyGlobals.lifes = 3
	MyGlobals.gameOver = 0
	$pos/fruitPickUp.position = fruitpos[rndnum.randi_range(0,5)]
	$Timer.start()
	#yield(get_tree().create_timer(1),"timeout")
	
func positionAllocator():
	$pos/Nav/follower1.position = followerpos[0]
	$pos/Nav/follower2.position = followerpos[1]
	$pos/Ghost.position = ghostpos[0]
	$pos/Ghost2.position = ghostpos[1]
	$pos/Ghost3.position = ghostpos[2]
	$pos/Ghost4.position = ghostpos[3]
	$pos/Player.position = playerpos[rndnum.randi_range(0,3)]
	
func _process(delta):
	
	if $joystick/TouchScreenButton.direction == "left":
		$pos/Player.velocity.x -= 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	elif $joystick/TouchScreenButton.direction == "right":
		$pos/Player.velocity.x += 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	elif $joystick/TouchScreenButton.direction == "up":
		$pos/Player.velocity.y -= 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	elif $joystick/TouchScreenButton.direction == "down":
		$pos/Player.velocity.y += 20
		$pos/Player.velocity = $pos/Player.velocity.normalized() * speed
		$pos/Player.move_player()
	
	var pos = $pos/Player.position
	var loc = $pos/Nav/GameScene.world_to_map(pos)
	var cell = $pos/Nav/GameScene.get_cell(loc.x,loc.y)
	if cell != -1:
		$pos/Nav/GameScene.set_cell(loc.x,loc.y,0)
	else:
		print($pos/Nav/GameScene.tile_set.tile_get_name(cell))
		
	sur_dis($pos/Ghost.position)
	sur_dis($pos/Ghost2.position)
	sur_dis($pos/Ghost3.position)
	sur_dis($pos/Ghost4.position)
	#sur_dis($pos/Nav/follower1.position)
	#sur_dis($pos/Nav/follower2.position)
	
	if(MyGlobals.score >= 10000 && MyGlobals.score < 15000 && extralifeReward1 == 0):
		extralifeReward1 = 1
		var tempLife = MyGlobals.lifes + 1
		MyGlobals.lifes = tempLife
		displayLife()
		print("rewarding first 1up")
	elif(MyGlobals.score >= 15000 && MyGlobals.score < 20000 && extralifeReward2 == 0):
		extralifeReward2 = 1
		var tempLife = MyGlobals.lifes + 1
		MyGlobals.lifes = tempLife
		displayLife()
		print("rewarding second 1up")
	elif(MyGlobals.score >= 20000 && extralifeReward3 == 0):
		extralifeReward3 = 1
		var tempLife = MyGlobals.lifes + 1
		MyGlobals.lifes = tempLife
		displayLife()
		print("rewarding second 1up")
#	if(MyGlobals.pickupCount == 50 && fruitSpawned == 0):
#		fruitSpawned = 1
#		MyGlobals.pickupCount = 0
#		#spawnFruit()
	get_node("Score/ScoreNumber").text = str(MyGlobals.score)
func resetStage():
	var tempLife = MyGlobals.lifes - 1
	if (tempLife < 0):
		MyGlobals.gameOver = 1
		$Gameover.visible = true
	else:
		MyGlobals.lifes = tempLife
		displayLife()
		positionAllocator()

func player_hit():
	positionAllocator()
func setPowerUp():
	var ghosts = get_tree().get_nodes_in_group("Ghost")
	for i in ghosts:
		i.set_modulate(Color(0,0,1))
func playerfollower(body):
	if body.is_in_group("Player") && MyGlobals.gameOver == 0:
		$deathSound.play()
		resetStage()

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
			

func sur_dis(ghostpos):
	#var ghostpos2 = $pos/Ghost2.position
	var ghostloc = $pos/Nav/GameScene.world_to_map(ghostpos)
	var ghostcell = $pos/Nav/GameScene.get_cell(ghostloc.x,ghostloc.y)
	if ghostcell != 1:
		$pos/Nav/GameScene.set_cell(ghostloc.x,ghostloc.y,1)


func _on_PowerupTimer_timeout():
	MyGlobals.powerUpActive = 0
	MyGlobals.eatCombo = 0
	var ghosts = get_tree().get_nodes_in_group("Ghost")
	for i in ghosts:
		i.set_modulate(Color(1,1,1))


func _on_Timer_timeout():
	if $pos/fruitPickUp.visible:
		$pos/fruitPickUp.invisible()
	else:
		$pos/fruitPickUp.position = fruitpos[rndnum.randi_range(0,5)]
		$pos/fruitPickUp.collector()
	$Timer.start()
