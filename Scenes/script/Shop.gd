extends MarginContainer

signal go_back
signal buy_rage_mode
signal buy_ammo_increase
signal buy_vertical_movement
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	emit_signal("go_back")
	hide()

func get_price(itemName):
	if itemName == "RageMode":
		return int($VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModePrice.text)
	if itemName == "VerticalMovement":
		return int($VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementPrice.text)
	if itemName == "AmmoIncrease":
		return int($VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncPrice.text)
	else:
		return str("check your spelling m8")
	

func update_price(itemName, value):
	if itemName == "RageMode":
		$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModePrice.text = str(value)
	if itemName == "VerticalMovement":
		$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementPrice.text = str(value)
	if itemName == "AmmoIncrease":
		$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncPrice.text = str(value)
	else:
		return str("check your spelling m8")


func _on_RageModeBuy_pressed():
	emit_signal("buy_rage_mode")

func _on_AmmoIncButton_pressed():
	emit_signal("buy_ammo_increase")

func _on_VerticalMovementButton_pressed():
	emit_signal("buy_vertical_movement")
