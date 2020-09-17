extends GridContainer

export var item_name = "ItemName"
export var item_price = 999
export var item_stock = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$ItemName.text = item_name
	$ItemPrice.text = str(item_price)
	$ItemStock.text = str(item_stock)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
