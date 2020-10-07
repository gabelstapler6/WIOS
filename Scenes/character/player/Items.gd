extends Node

var consumable_items = [
	{
		"description": "Rage-Mode (unlimited Ammo for 10sec)",
		"price": 123,
		"name": "RageMode"
	},
	{
		"description": "Start your NEXT Run with the Ammo you buy",
		"price": 20,
		"name": "StartAmmo"
	}
]

var upgrade_items = [
	{
		"description": "Ammo increase +1 every 10sec",
		"price": 1000,
		"name": "AmmoIncrease"
	},
	{
		"description": "Enable vertical movement",
		"price": 1312,
		"name": "VerticalMovement"
	}
]

var items = {
	"consumable_items": consumable_items,
	"upgrade_items": upgrade_items
}

func _ready():
	pass
