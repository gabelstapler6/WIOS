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


func increase_rage_mode_stock():
	var stock = int($VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModeStock.text) 
	stock += 1
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModeStock.text = str(stock)
	
func decrease_rage_mode_stock():
	var stock = int($VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModeStock.text) 
	stock -= 1
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModeStock.text = str(stock)
	
func _on_Player_rage_mode_bought():
	# show_success_popup()
	increase_rage_mode_stock()

func increase_ammo_increase_stock():
	var stock = int($VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncStock.text) 
	stock += 1
	$VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncStock.text = str(stock)

func _on_Player_ammo_increase_bought():
	increase_ammo_increase_stock()
	
