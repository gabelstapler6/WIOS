extends Node

var vertical_movement = false
var inventory = {}
var score_balance = 0
var highscore = 0

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
		"score_balance": score_balance,
		"highscore": highscore
	}
	for key in inventory:
		save_dict[key] = inventory[key]
	
	return save_dict
