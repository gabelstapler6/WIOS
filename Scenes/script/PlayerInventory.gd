extends Node

var inventory = {}
var score_balance = 0
var highscore = 0
var username = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("persistence")
	for i in Items.items:
		var stock = 0
		if i.name == "AmmoIncrease":
			stock = 1
		inventory[i.name + "Stock"] = stock


func save():
	var save_dict = {
		"filename": "PlayerInventory",
		"score_balance": score_balance,
		"highscore": highscore,
		"inventory": inventory,
		"username": username
	}
	
	return save_dict
