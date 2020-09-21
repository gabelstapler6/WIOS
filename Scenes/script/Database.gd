extends Node


const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var path_to_db = "res://data"

var Player_Table = "Player"
var where_user_is = "username = "

var Items_Table = "Items"

var Inventory_Table = "Inventory"
var inventory_array


# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = path_to_db
	
	if db.open_db() :
		print("Database opened successfully")
	else:
		print(db.error_message)
		return
	
	db.verbose_mode = true
	db.foreign_keys = true
	# db.import_from_json("res://json_export.json")
	db.export_to_json("res://data.json")
	# alle items in ein Array speichern
	
	if check_password("yunggabel", "yunggabel123"):
		setup_inventory()

func check_password(username, pw):
	username = "'" + username + "'"
	var current_player = db.select_rows(Player_Table, where_user_is + username, ["*"])
	
	for i in current_player:
		if i["password"] == pw:
			# sobald das hier ausgefuehrt wird ist der Spieler eingeloggt
			where_user_is += username
			return true
			
	return false

# fuellt das inventory des Players mit den Startitems, falls noch nicht getan
func setup_inventory():	
	db.select_rows(Inventory_Table)
	
	# eine 2. db verbindung muss eingerichtet werden um mehrere Tabellen in arrays zu speichern
	var db2 = SQLite.new()
	db2.path = path_to_db
	db2.open_db()
	var current_player = db2.select_rows(Player_Table, where_user_is, ["*"])
	
	var items_array = db.select_rows(Items_Table, "", ["*"])
	
	var def_stock = 0
	var join = []
	for i in current_player:
		for j in items_array:
			if j["name"] == "AmmoIncrease":
				def_stock = 1
			join.append({"stock": def_stock, "playerID": i["ID"], "itemID": j["ID"]})
			def_stock = 0
			
	db2.close_db()
	db.insert_rows(Inventory_Table, join)


func update_player_scoreBalance(scoreBalance):
	db.update_rows(Player_Table, where_user_is, {"scoreBalance": scoreBalance})
	
func update_player_highscore(run_score):
	var selected_array = db.select_rows(Player_Table, where_user_is, ["highscore"])
	
	for i in selected_array:
		if i["highscore"] < run_score:
			db.update_rows(Player_Table, where_user_is, {"highscore": run_score})

func update_item_stock(item_name, stock):
	pass
