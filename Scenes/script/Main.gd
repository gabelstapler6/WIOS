extends Node


export (PackedScene) var Tile
export (PackedScene) var Bullet
var score
var score_balance
var score_multiplier = 2

var cycle_counter = 0

var highscore_list
var save_path

onready var gui = $GUI
onready var player = $Player
onready var client = $WiosClient
onready var ingame_bg = $InGameBackground
# var db

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	ingame_bg.set_process(false)
	# db = $Database
	# db.open_connection()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	player.shooting = false
	get_tree().call_group("tiles", "queue_free")
	ingame_bg.set_process(false)
	
	var curr_multiplier = score_multiplier - 1
	score_balance = score
	
	# check if current run was a new Highscore 
	if PlayerInventory.highscore < score:
		# db.update_player_highscore(score)
		PlayerInventory.highscore = score
		client.post_highscore(PlayerInventory.username, PlayerInventory.highscore)
		
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
	PlayerInventory.score_balance += score_balance
	# db.update_player_scoreBalance(player.score)
	gui.update_score_tag(PlayerInventory.score_balance)
		
	gui.show_game_over()
	score_multiplier = 2
	cycle_counter = 0
	save_game()

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var tile = Tile.instance()
	add_child(tile)
	
	tile.position = $MobPath/MobSpawnLocation.position
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	var diff = 0
	if score >= 400:
		if score >= 600:
			diff += 25
		diff += 25
	tile.linear_velocity = Vector2(direction, rand_range(tile.min_speed + diff, tile.max_speed + diff))


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
		if $MobTimer.wait_time <= 0.3:
			cycle_counter += 1
		if $MobTimer.wait_time == 0.5:
			cycle_counter += 1
			
		if cycle_counter % 2 == 1:
			$MobTimer.wait_time -= 0.1
			
			message = "more meteorites ahead!"
		else:
			$MobTimer.wait_time += 0.1
			message = "the field becomes less dense!"
			
		if score == 400 or score == 600:
			message += "\nspeed increases!"
		
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
	ingame_bg.set_process(true)
	player.shooting = true
	player.ammo = 0
	$MobTimer.wait_time = 0.5
	score = 0
	player.start($StartPosition.position)
	$StartTimer.start()
	player.emit_signal("ammo_change", player.ammo)
	
	gui.update_score(score)
	
# func _on_LoginView_enter_pressed():
# 	if db.check_username(gui.get_username()):
		
# 		db.setup_game()
		
# 		player_values = db.retrieve_player_values()
# 		player.inventory.init(db.get_player_inventory())
# 		items_array = db.get_items_array()
		
# 		update_ammo_price()
# 		player.vertical_movement_enabled()
		
# 		player.score = player_values.scoreBalance

# 		gui.setup_gui(player_values, items_array, player.inventory.stock_dict)
# 	else:
# 		gui.login_view.popup.dialog_text = "This username does not exist!\nYou can add a new User with the 'add user' Button."
# 		gui.login_view.popup.popup_centered_minsize()
	
func update_ammo_price():
	var name = "AmmoIncrease"
	for i in Items.items:
		if i["name"] == name:
			i["price"] = PlayerInventory.inventory[name + "Stock"] * 1000
			gui.shop.update_shop_price(i["name"], i["price"])


func item_bought(item_name):
	var stock = PlayerInventory.inventory[item_name + "Stock"]
	# db.update_item_stock(item_name, stock)
	# db.update_player_scoreBalance(player.score)
	gui.update_score_tag(PlayerInventory.score_balance)
	gui.shop.update_shop_stock(item_name, stock)


func buy_item(item_name):
	for i in Items.items:
		if i["name"] == item_name:
			if PlayerInventory.score_balance >= i["price"]:
				PlayerInventory.score_balance -= i["price"]
				PlayerInventory.inventory[item_name + "Stock"] += 1
				item_bought(item_name)
				update_ammo_price()
				save_game()
				return
			else:
				gui.shop.show_buy_fail()


func _on_Player_inventory_stock_changed(item_name, stock):
	# db.update_item_stock(item_name, stock)
	gui.shop.update_shop_stock(item_name, stock)


# func refresh_highscores():
	# var player_array = db.get_all_players_highscores()
	
	# for _i in range(1, player_array.size()):
	# 	for j in range(0, player_array.size() - 1):
	# 		if player_array[j].highscore < player_array[j+1].highscore:
	# 			var c = player_array[j]
	# 			player_array[j]= player_array[j+1]
	# 			player_array[j+1] = c
			
	# gui.highscores.add_entries(player_array)


# func _on_Main_tree_exiting():
# 	db.close_connection()


# func _on_LoginView_add_user_pressed():
# 	if db.check_username(gui.login_view.get_username()):
# 		gui.login_view.popup.dialog_text = "This user already exists!\nPick another username!"
# 		gui.login_view.popup.popup_centered_minsize()
# 	else:
# 		db.add_user(gui.login_view.get_username())


func save_game():
	var save = File.new()
	save.open_encrypted_with_pass(save_path, File.WRITE, "VeryHardPassword")
	# save.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persistence")

	for i in save_nodes:
		if !i.has_method("save"):
			print("Node: %s has no save() function" % i.name)
			continue

		var node_data = i.call("save")
		save.store_line(to_json(node_data))
	
	save.close()


func load_game():
	var save = File.new()
	if not save.file_exists(save_path):
	# if not save.file_exists("user://savegame.save"):
		return

	# var save_nodes = get_tree().get_nodes_in_group("persistence")
	# for i in save_nodes:
	# 	i.queue_free()

	save.open_encrypted_with_pass(save_path, File.READ, "VeryHardPassword")
	# save.open("user://savegame.save", File.READ)
	
	while save.get_position() < save.get_len():
		var node_data = parse_json(save.get_line())

		for key in node_data:
			if node_data["filename"] == "Items":
				Items.set(key, node_data[key])
			else:
				PlayerInventory.set(key, node_data[key])

	save.close()



func show_highscores():
	client.retrieve_highscore_list()


func _on_WiosClient_data_arrived(data):
	highscore_list = data
	gui.highscores.add_entries(highscore_list)
	gui.show_highscores()

