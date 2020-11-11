extends MarginContainer

signal go_back
signal buy_item(item_name)

onready var popup = $VBox/ShopVBox/ItemsCenter/PopupNotification
onready var items_grid = $VBox/ShopVBox/ItemsCenter/ItemsVBox/Items
onready var warning_label = $VBox/ShopVBox/WarningLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_BackButton_pressed():
	emit_signal("go_back")
	warning_label.text = ""
	hide()


func show_buy_fail():
	warning_label.text = "You have not enough Score to buy this!"


func vertical_movement_bought():
	var nodes = get_tree().get_nodes_in_group("VerticalMovement")
	for node in nodes:
		node.add_color_override("font_color", "8a8a8a")
		if "disabled" in node:
			node.disabled = true


# update func for price and stock of the item in the parameter
func update_shop(item_name, value, attribute="Stock"):
	var nodes = get_tree().get_nodes_in_group(item_name + attribute)
	for node in nodes:
		node.text = str(value)
	

func buy_item(item_name):
	warning_label.text = ""
	emit_signal("buy_item", item_name)
	
	

func fill_shop():
	var group_name
	for key in Items.items:
		for item in Items.items[key]:
			group_name = item["name"]
			for item_key in item:
				if item_key == "name":
					continue
				var label = Label.new()
				if item_key == "price":
					label.add_to_group(group_name + "Price")
					label.align = Label.ALIGN_CENTER
					
				label.add_to_group(group_name)
				label.text = str(item[item_key])
				label.add_font_override("font", GlobalTheme.text_font)
				items_grid.add_child(label)
				
			var stock_label = Label.new()
			stock_label.add_to_group(group_name + "Stock")
			stock_label.add_to_group(group_name)
			stock_label.text = str(PlayerInventory.inventory[group_name + "Stock"])
			stock_label.add_font_override("font", GlobalTheme.text_font)
			stock_label.align = Label.ALIGN_CENTER
			items_grid.add_child(stock_label)
			
			var buy_button = Button.new()
			buy_button.add_to_group(group_name)
			items_grid.add_child(buy_button)
			buy_button.text = "buy"
			buy_button.add_font_override("font", GlobalTheme.text_font)
			buy_button.flat = true
			
			buy_button.connect("pressed", self, "buy_item", [group_name])
	if PlayerInventory.inventory["VerticalMovementStock"] >= 1:
		vertical_movement_bought()

