extends Node


var items = [
	{
		"name": "RageMode",
		"price": 242
	},
	{
		"name": "AmmoIncrease",
		"price": 1000
	},
	{
		"name": "VerticalMovement",
		"price": 1312
	}
]

	

func _ready():
	add_to_group("persistence")
	pass

func save():
	var save_dict = items
	return save_dict
