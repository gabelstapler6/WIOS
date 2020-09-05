extends Node


export (PackedScene) var Tile
export (PackedScene) var Bullet
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("tiles", "queue_free")
	$Player.ammo = 3
	$Player.shooting = false
	$Player.vertical_movement = false
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var tile = Tile.instance()
	add_child(tile)
	
	tile.position = $MobPath/MobSpawnLocation.position
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2

	tile.linear_velocity = Vector2(direction, rand_range(tile.min_speed, tile.max_speed))


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
	if score == 20:
		$Player.vertical_movement = true
		$HUD.show_message("Level up!\nVertical movement enabled!")
	
	if score == 60:
		$Player.shooting = true
		$HUD.show_message("Level up!\nshooting enabled!")
		$HUD/AmmoCount.show()
		$Player.emit_signal("ammo_change")
		
	if score > 60:
		if score % 10 == 0:
			$Player.ammo += 3
			$Player.emit_signal("ammo_change")


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
	$HUD/AmmoCount.text = "Ammo: " + str($Player.ammo)
