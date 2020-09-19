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
	

func _on_RageModeBuy_pressed():
	emit_signal("buy_rage_mode")

func _on_AmmoIncButton_pressed():
	emit_signal("buy_ammo_increase")

func _on_VerticalMovementButton_pressed():
	emit_signal("buy_vertical_movement")


func _on_Player_not_enough_cash_mf():
	$VBox/ShopVBox/ItemsCenter/PopupNotification.dialog_text = "You have not enough Score to buy this!"
	$VBox/ShopVBox/ItemsCenter/PopupNotification.popup_centered_minsize()

func show_success_popup():
	$VBox/ShopVBox/ItemsCenter/PopupNotification.dialog_text = "Item successfully bought!"
	$VBox/ShopVBox/ItemsCenter/PopupNotification.popup_centered_minsize()

func _on_Player_vertical_movement_bought():
	#show_success_popup()
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementButton.disabled = true
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementStock.text = "1"
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovement.add_color_override("font_color", "8a8a8a")
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementStock.add_color_override("font_color", "8a8a8a")
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementPrice.add_color_override("font_color", "8a8a8a")
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementButton.add_color_override("font_color", "8a8a8a")


func update_shop_stock(rage_stock, ammo_stock, vertical_stock):
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncStock.text = str(ammo_stock)
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModeStock.text = str(rage_stock)
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementStock.text = str(vertical_stock)


func _on_Player_update_shop_price(rage_price, ammo_price, vertical_price):
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncPrice.text = str(ammo_price)
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModePrice.text = str(rage_price)
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementPrice.text = str(vertical_price)
