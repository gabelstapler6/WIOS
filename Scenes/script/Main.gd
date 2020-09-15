extends Node


export (PackedScene) var Tile
export (PackedScene) var Bullet
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Music.play()
	$GUI.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$GUI.show_game_over()
	get_tree().call_group("tiles", "queue_free")
	$MobTimer.wait_time = 0.5
	$Player.ammo = 3
	$Player.score += score
	$MainMenu.update_score($Player.score)
	

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var tile = Tile.instance()
	add_child(tile)
	
	tile.position = $MobPath/MobSpawnLocation.position
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2

	tile.linear_velocity = Vector2(direction, rand_range(tile.min_speed, tile.max_speed))


func _on_ScoreTimer_timeout():
	score += 1
	$GUI.update_score(score)
		
	if score % 10 == 0:
		$Player.ammo += 3
		if score > 100:
			$Player.ammo += 3
		if score > 200:
			$Player.ammo += 1
			
		$Player.emit_signal("ammo_change")
		
	if score == 100:
		$MobTimer.wait_time = 0.25
		$GUI.show_message("Watch out!")
		
	if score == 200:
		$MobTimer.wait_time = 0.20
		$GUI.show_message("Watch out!")


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


func _on_Player_ammo_change():
	$GUI/VBoxContainer/AmmoCount.text = "Ammo: " + str($Player.ammo)


func _on_MainMenu_sound_off():
	$Music.stop()

func _on_MainMenu_sound_on():
	$Music.play()


func _on_MainMenu_start_game():
	score = 0
	$GUI.show()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$GUI.update_score(score)
	$GUI.show_message("Get Ready")
	$Player.emit_signal("ammo_change")


func _on_GUI_main_menu():
	$MainMenu.show()
