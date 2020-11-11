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
		client.call_server_function("post_highscore", {"username": PlayerInventory.username, "score": score})
		
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
	gui.update_score_tag(PlayerInventory.score_balance)
		
	gui.show_game_over()
	score_multiplier = 2
	cycle_counter = 0
	save_user_stats()


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
	
	player.ammo = PlayerInventory.inventory["StartAmmoStock"]
	PlayerInventory.inventory["StartAmmoStock"] = 0
	gui.shop.update_shop("StartAmmo", 0)
	
	$MobTimer.wait_time = 0.5
	score = 0
	player.start($StartPosition.position)
	$StartTimer.start()
	player.emit_signal("ammo_change", player.ammo)
	
	gui.update_score(score)
	
func update_ammo_price():
	for key in Items.items:
		for item in Items.items[key]:
			if item["name"] == "AmmoIncrease":
				item["price"] = PlayerInventory.inventory["AmmoIncreaseStock"] * 1000
				gui.shop.update_shop(item["name"], item["price"], "Price")


func item_bought(item_name):
	var stock = PlayerInventory.inventory[item_name + "Stock"]
	# db.update_item_stock(item_name, stock)
	# db.update_player_scoreBalance(player.score)
	gui.update_score_tag(PlayerInventory.score_balance)
	gui.shop.update_shop(item_name, stock, "Stock")
	if item_name == "VerticalMovement":
		gui.shop.vertical_movement_bought()


func buy_item(item_name):
	for key in Items.items:
		for item in Items.items[key]:
			if item["name"] == item_name:
				if PlayerInventory.score_balance >= item["price"]:
					PlayerInventory.score_balance -= item["price"]
					PlayerInventory.inventory[item_name + "Stock"] += 1
					item_bought(item_name)
					if item_name == "AmmoIncrease":
						update_ammo_price()
					save_user_stats()
					return
				else:
					gui.shop.show_buy_fail()


func _on_Player_inventory_stock_changed(item_name, stock):
	# db.update_item_stock(item_name, stock)
	gui.shop.update_shop(item_name, stock, "Stock")


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
				PlayerInventory.set(key, node_data[key])

	save.close()


func highscores_received(data):
	highscore_list = data
	gui.highscores.add_entries(highscore_list)
	gui.show_highscores()

func show_highscores():
	client.call_server_function("get_highscore_list", {})


func login_received(data):
	if data["correct"]:
		for key in data["game_save"]:
			# load playersave from server
			PlayerInventory.set(key, data["game_save"][key])
			
		gui.setup_gui()
		gui.show_gui()	
	else:
		gui.startup.show_warning_message("Wrong username or password")

func login(username, password):
	client.call_server_function("login_user", {"username": username, "password": password})
	PlayerInventory.username = username


func save_user_stats():
	client.call_server_function("save_user_stats_to_file", {"username": PlayerInventory.username, "inventory": PlayerInventory.save()})

func register_received(data):
	if data:
		gui.startup.show_warning_message("This username is already taken! You need to pick another one")
	else:
		gui.startup.show_warning_message("Registered successfully! You can login now")


func register(username, password):
	client.call_server_function("register_user", {"username": username, "password": password})

