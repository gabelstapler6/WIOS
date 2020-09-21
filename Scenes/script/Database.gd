extends Node


const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var path_to_db = "res://data"
var json_path = "res://data.json"

var Player_Table = "Player"
var where_user_is = "username = "
var logged_player = {}

var Items_Table = "Items"
var items_array = []

var Inventory_Table = "Inventory"
# var inventory_array = []

var current_select


# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = path_to_db
	
	db.verbose_mode = true
	db.foreign_keys = true
	
	open_connection()
	
	current_select = db.select_rows(Items_Table, "", ["*"])
	for i in current_select:
		items_array.append(i)


func close_connection():
	db.export_to_json(json_path)
	db.close_connection()
	
func open_connection():
	db.import_from_json(json_path)
	if db.open_db() :
		print("Database opened successfully")
	else:
		print(db.error_message)
		return
	

func check_password(username, pw):
	username = "'" + username + "'"
	current_select = db.select_rows(Player_Table, where_user_is + username, ["*"])
	
	for i in current_select:
		if i["password"] == pw:
			# sobald das hier ausgefuehrt wird ist der Spieler eingeloggt
			where_user_is += username
			logged_player = {
				"ID": i["ID"],
				"username": i["username"],
				"scoreBalance": i["scoreBalance"],
				"highscore": i["highscore"]
				}
			return true
			
	return false

# fuellt das inventory des Players mit den Startitems, falls noch nicht getan
func setup_inventory():	
	current_select = db.select_rows(Inventory_Table, "playerID=" + str(logged_player.ID), ["*"])
	if current_select.size() == 3:
		return
	
	current_select = db.select_rows(Items_Table, "", ["*"])
	
	var def_stock = 0
	var join = []
	for j in current_select:
		if j["name"] == "AmmoIncrease":
			def_stock = 1
		join.append({"stock": def_stock, "playerID": logged_player.ID, "itemID": j["ID"]})
		def_stock = 0
			
	db.insert_rows(Inventory_Table, join)


func update_player_scoreBalance(scoreBalance):
	db.update_rows(Player_Table, where_user_is, {"scoreBalance": scoreBalance})
	

func update_player_highscore(run_score):
	current_select = db.select_rows(Player_Table, where_user_is, ["highscore"])
	for i in current_select:
		if i["highscore"] < run_score:
			db.update_rows(Player_Table, where_user_is, {"highscore": run_score})


func update_item_stock(item_name, stock):
	for i in items_array:
		if i["name"] == item_name:
			db.update_rows(Inventory_Table, "itemID=" + str(i["ID"]), {"stock": stock})
			return

func retrieve_player_values():
	var dict = {
		"username": logged_player.username,
		"scoreBalance": logged_player.scoreBalance,
		"highscore": logged_player.highscore
	}
	current_select = db.select_rows("Inventory, Items", "playerID=" + str(logged_player.ID) + " AND Items.ID = itemID", ["*"])
	for i in current_select:
		dict[i["name"] + "_stock"] = i["stock"]
		
	return dict
