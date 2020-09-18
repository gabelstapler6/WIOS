extends Node


export (PackedScene) var Tile
export (PackedScene) var Bullet
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Canvas/PlayerScoreBalance.update_score($Player.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Canvas/GUI.show_game_over()
	$Canvas/SoundButton.show()
	get_tree().call_group("tiles", "queue_free")
	if score > 200:
		var help = score - 200
		help *= 2
		if score > 400:
			var help2 = score - 400
			help2 *= 4
			score += help2
		score += help
		
	$Player.score += score
	$Canvas/PlayerScoreBalance.update_score($Player.score)
	$Player.shooting = false
	

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var tile = Tile.instance()
	add_child(tile)
	
	tile.position = $MobPath/MobSpawnLocation.position
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2

	tile.linear_velocity = Vector2(direction, rand_range(tile.min_speed, tile.max_speed))


func _on_ScoreTimer_timeout():
	score += 1
	$Canvas/GUI.update_score(score)
		
	if score % 10 == 0:
		$Player.add_ammo()
		if score > 50:
			$Player.add_ammo()
		if score > 100:
			$Player.add_ammo()
		if score > 150:
			$Player.add_ammo()
		if score > 200:
			$Player.add_ammo()
	
	if score == 50:
		$MobTimer.wait_time = 0.4
		$Canvas/GUI.show_message("Watch out!")

	if score == 100:
		$MobTimer.wait_time = 0.3
		$Canvas/GUI.show_message("Watch out!")
	
	if score == 150:
		$MobTimer.wait_time = 0.2
		$Canvas/GUI.show_message("Watch out!")
		
	if score == 200:
		$MobTimer.wait_time = 0.1
		$Canvas/GUI.show_message("Watch out!\n2x Score multiplier!")
	
	if score == 250:
		$MobTimer.wait_time = 0.2
		$Canvas/GUI.show_message("you made the hardest part bro")
		
	if score == 300:
		$MobTimer.wait_time = 0.3
		$Canvas/GUI.show_message("chill a little")
		
	if score == 400:
		$MobTimer.wait_time = 0.2
		$Canvas/GUI.show_message("Watch out!\n4x Score multiplier!")

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_Player_shoot_bullet():
	var bullet = Bullet.instance()
	bullet.add_to_group("tiles")
	add_child(bullet)
	bullet.position = $Player.get_position()
	bullet.position.y -= 100
	bullet.linear_velocity = Vector2(1, -bullet.speed)

func _on_MainMenu_start_game():
	$Player.shooting = true
	$Player.ammo = 0
	$Player.add_ammo()
	$MobTimer.wait_time = 0.5
	score = 0
	$Canvas/GUI.show()
	$Canvas/PlayerScoreBalance.hide()
	$Canvas/SoundButton.hide()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Canvas/GUI.update_score(score)
	$Canvas/GUI.show_message("Get Ready")
	$Player.emit_signal("ammo_change", $Player.ammo)


func _on_GUI_main_menu():
	$Canvas/MainMenu.show()
	$Canvas/PlayerScoreBalance.show()
