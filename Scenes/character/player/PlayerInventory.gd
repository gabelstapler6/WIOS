extends Node

var inventory = {}
var score_balance = 0
var highscore = 0
var username = ""
var password = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("persistence")
	for item_category in Items.items:
		for item in Items.items[item_category]:
			var stock = 0
			if item["name"] == "AmmoIncrease":
				stock = 1
			var key = item["name"] + "Stock"
			inventory[key] = stock
	


func save():
	var save_dict = {
		"filename": "PlayerInventory",
		"score_balance": score_balance,
		"highscore": highscore,
		"inventory": inventory
	}
	
	return save_dict
