extends Node


export (PackedScene) var Tile
export (PackedScene) var Bullet
var score
var score_balance
var score_multiplier = 2

var cycle_counter = 1


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
	get_tree().call_group("tiles", "queue_free")
	
	score_balance = score
	# score wird bei 200 2x, bei 400 3x, 600 4x usw multiplied 
	# nur die Differenz zu den Stufen wird multipliziert
	if score > 200:
		var i = 2
		while i <= score_multiplier:
			var x = 0
			var help = score - ((i + x) * 100)
			help *= i
			score_balance += help
			i += 1
			x += 1
		
	$Player.score += score_balance
	$Canvas/PlayerScoreBalance.update_score($Player.score)
	$Player.shooting = false
	$Canvas/VersionTag.show()

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
	
	if score % 50 == 0:
		if $MobTimer.wait_time == 0.1:
			cycle_counter += 1
			
		if cycle_counter % 2 == 1:
			$MobTimer.wait_time -= 0.1
		else:
			$MobTimer.wait_time += 0.1
		
		if score % 200 == 0:
			$Canvas/GUI.show_message( str(score_multiplier) + "x Score multiplier!")
			score_multiplier += 1
			return
		$Canvas/GUI.show_message("Tiles spawn faster\nwatch out!")

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
	$Canvas/VersionTag.hide()
	$Player.shooting = true
	$Player.ammo = 0
	$Player.add_ammo()
	$MobTimer.wait_time = 0.5
	score = 0
	$Canvas/GUI.show()
	$Canvas/PlayerScoreBalance.hide()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Canvas/GUI.update_score(score)
	$Canvas/GUI.show_message("Get Ready")
	$Player.emit_signal("ammo_change", $Player.ammo)
	$Canvas/GUI.is_disabled(false)


func _on_GUI_main_menu():
	$Canvas/MainMenu.show()
	$Canvas/PlayerScoreBalance.show()


func _on_GUI_save_button_pressed():
	$Canvas/GUI.set_highscore_entry(score)
	$Canvas/GUI.is_disabled(true)
