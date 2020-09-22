extends Node


export (PackedScene) var Tile
export (PackedScene) var Bullet
var score
var score_balance
var score_multiplier = 2

var cycle_counter = 1

var player_values
var items_array


onready var gui = $GUI
onready var player = $Player
var db

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	db = $Database
	db.open_connection()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	player.shooting = false
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
		
	player.score += score_balance
	gui.update_score_tag(player.score)
	# den run in die Datenbank packen
	db.update_player_scoreBalance(player.score)
	if player_values["highscore"] < score:
		db.update_player_highscore(score)
		player_values["highscore"] = score
		
	gui.show_game_over(player_values["highscore"])

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var tile = Tile.instance()
	add_child(tile)
	
	tile.position = $MobPath/MobSpawnLocation.position
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2

	tile.linear_velocity = Vector2(direction, rand_range(tile.min_speed, tile.max_speed))


func _on_ScoreTimer_timeout():
	score += 1
	gui.update_score(score)
		
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
			gui.show_message( str(score_multiplier) + "x Score multiplier!")
			score_multiplier += 1
			return
		gui.show_message("Tiles spawn faster\nwatch out!")


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_Player_shoot_bullet():
	var bullet = Bullet.instance()
	bullet.add_to_group("tiles")
	add_child(bullet)
	bullet.position = player.get_position()
	bullet.position.y -= 100
	bullet.linear_velocity = Vector2(1, -bullet.speed)


func _on_MainMenu_start_game():
	player.shooting = true
	player.ammo = 0
	player.add_ammo()
	$MobTimer.wait_time = 0.5
	score = 0
	player.start($StartPosition.position)
	$StartTimer.start()
	player.emit_signal("ammo_change", player.ammo)
	
	gui.update_score(score)
	

func _on_LoginView_enter_pressed():
	if db.check_password(gui.get_username(), gui.get_password()):
		
		db.setup_game()
		
		player_values = db.retrieve_player_values()
		player.inventory.init(db.get_player_inventory())
		items_array = db.get_items_array()
		
		update_ammo_price()
		player.vertical_movement_enabled()
		
		player.score = player_values.scoreBalance

		gui.setup_gui(player_values, items_array, player.inventory.stock_dict)
	else:
		#TODO fail popup
		pass
	
func update_ammo_price():
	for i in items_array:
			if i["name"] == "AmmoIncrease":
				i["price"] = player.inventory.stock_dict["AmmoIncrease_stock"] * 1000
				gui.shop.update_shop_price(i["name"], i["price"])


func item_bought(item_name):
	var stock = player.inventory.stock_dict[item_name + "_stock"]
	db.update_item_stock(item_name, stock)
	db.update_player_scoreBalance(player.score)
	gui.update_score_tag(player.score)
	gui.shop.update_shop_stock(item_name, stock)
	player.vertical_movement_enabled()


func buy_item(item_name):
	for i in items_array:
		if i["name"] == item_name:
			if player.score >= i["price"]:
				player.score -= i["price"]
				player.inventory.stock_dict[item_name+"_stock"] += 1
				item_bought(item_name)
				update_ammo_price()
				return
			else:
				gui.shop.show_buy_fail()


func _on_Player_inventory_stock_changed(item_name, stock):
	db.update_item_stock(item_name, stock)
	gui.shop.update_shop_stock(item_name, stock)


func refresh_highscores():
	var player_array = db.get_all_players_highscores()
	
	for i in range(1, player_array.size()):
		for j in range(0, player_array.size() - 1):
			if player_array[j].highscore < player_array[j+1].highscore:
				var c = player_array[j]
				player_array[j]= player_array[j+1]
				player_array[j+1] = c
			
	gui.highscores.add_entries(player_array)
