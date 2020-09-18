extends Node

var vertical_movement = false
var vertical_movement_stock = 0
var rage_mode_stock = 0
var ammo_increase_stock = 1

signal update_shop_stock(rage_stock, ammo_stock, vertical_stock)
signal update_shop_price(rage_price, ammo_price, vertical_price)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("update_shop_stock", rage_mode_stock, ammo_increase_stock, vertical_movement_stock)
	emit_signal("update_shop_price", $Items.rage_mode_price, $Items.ammo_increase_price, $Items.vertical_movement_price)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
