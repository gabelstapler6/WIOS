extends Node


var items = [
	{
		"name": "RageMode",
		"price": 64
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
	var save_dict = {
		"filename": "Items",
		"items": items
	}
	return save_dict
