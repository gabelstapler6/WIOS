extends MarginContainer

signal go_back
signal buy_item(item_name)

onready var popup = $VBox/ShopVBox/ItemsCenter/PopupNotification

onready var vertical_movement_button = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementButton
onready var vertical_movement_stock = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementStock
onready var vertical_movement_label = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovement
onready var vertical_movement_price = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/VerticalMovementPrice
onready var ammo_increase_stock = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncStock
onready var ammo_increase_price = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/AmmoIncPrice
onready var rage_mode_stock = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModeStock
onready var rage_mode_price = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items/RageModePrice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_BackButton_pressed():
	emit_signal("go_back")
	hide()


func show_buy_fail():
	popup.dialog_text = "You have not enough Score to buy this!"
	popup.popup_centered_minsize()


func vertical_movement_bought():
	vertical_movement_button.disabled = true
	vertical_movement_stock.text = "1"
	vertical_movement_label.add_color_override("font_color", "8a8a8a")
	vertical_movement_stock.add_color_override("font_color", "8a8a8a")
	vertical_movement_price.add_color_override("font_color", "8a8a8a")
	vertical_movement_button.add_color_override("font_color", "8a8a8a")


func update_shop_stock(item_name, value):
	if item_name == "VerticalMovement":
		if value > 0:
			vertical_movement_bought()
		vertical_movement_stock.text = str(value)
	if item_name == "AmmoIncrease":
		ammo_increase_stock.text = str(value)
	if item_name == "RageMode":
		rage_mode_stock.text = str(value)


func update_shop_price(item_name, value):
	if item_name == "VerticalMovement":
		vertical_movement_price.text = str(value)
	if item_name == "AmmoIncrease":
		ammo_increase_price.text = str(value)
	if item_name == "RageMode":
		rage_mode_price.text = str(value)
		

func buy_item(item_name):
	emit_signal("buy_item", item_name)
	
