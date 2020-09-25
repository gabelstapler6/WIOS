extends Node


export (PackedScene) var Tile
export (PackedScene) var Bullet
var score
var score_balance
var score_multiplier = 2

var cycle_counter = 0

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
	
	var curr_multiplier = score_multiplier - 1
	score_balance = score
	
	# check if current run was a new Highscore 
	if player_values["highscore"] < score:
		db.update_player_highscore(score)
		player_values["highscore"] = score
		
	# score multiplies at 200 2x, 300 3x and so on
	# only the difference to another stage gets multiplied
	if score > 200:
		for i in range(curr_multiplier, 1, -1):
			var help = score - i*100
			score -= help
			score_balance -= help
			help *= i
			score_balance += help
			
	# add the cash
	player.score += score_balance
	db.update_player_scoreBalance(player.score)
	gui.update_score_tag(player.score)
		
	gui.show_game_over(player_values["highscore"])
	score_multiplier = 2
	cycle_counter = 0

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
		player.add_ammo()
		# every 100 score 1 ammo gets added
		# for _i in range(100, score+1, 100):
			# player.add_ammo()
	var message
	if score % 50 == 0:
		if $MobTimer.wait_time <= 0.2:
			cycle_counter += 1
		if $MobTimer.wait_time == 0.5:
			cycle_counter += 1
			
		if cycle_counter % 2 == 1:
			$MobTimer.wait_time -= 0.1
			
			message = "Tiles spawn faster!"
		else:
			$MobTimer.wait_time += 0.1
			message = "Tiles slow down!"
			
		
		if score >= 200:
			if score % 100 == 0:
				gui.show_message( message + "\n" + str(score_multiplier) + "x Score multiplier!")
				score_multiplier += 1
				return
		gui.show_message(message)


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
	$MobTimer.wait_time = 0.5
	score = 0
	player.start($StartPosition.position)
	$StartTimer.start()
	player.emit_signal("ammo_change", player.ammo)
	
	gui.update_score(score)
	

func _on_LoginView_enter_pressed():
	if db.check_username(gui.get_username()):
		
		db.setup_game()
		
		player_values = db.retrieve_player_values()
		player.inventory.init(db.get_player_inventory())
		items_array = db.get_items_array()
		
		update_ammo_price()
		player.vertical_movement_enabled()
		
		player.score = player_values.scoreBalance

		gui.setup_gui(player_values, items_array, player.inventory.stock_dict)
	else:
		gui.login_view.popup.dialog_text = "This username does not exist!\nYou can add a new User with the 'add user' Button."
		gui.login_view.popup.popup_centered_minsize()
	
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
	
	for _i in range(1, player_array.size()):
		for j in range(0, player_array.size() - 1):
			if player_array[j].highscore < player_array[j+1].highscore:
				var c = player_array[j]
				player_array[j]= player_array[j+1]
				player_array[j+1] = c
			
	gui.highscores.add_entries(player_array)


func _on_Main_tree_exiting():
	db.close_connection()


func _on_LoginView_add_user_pressed():
	if db.check_username(gui.login_view.get_username()):
		gui.login_view.popup.dialog_text = "This user already exists!\nPick another username!"
		gui.login_view.popup.popup_centered_minsize()
	else:
		db.add_user(gui.login_view.get_username())
