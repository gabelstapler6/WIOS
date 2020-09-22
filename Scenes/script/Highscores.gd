extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var scroll_vbox = $VBox/Scroll/VBox
var font

# Called when the node enters the scene tree for the first time.
func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://Assets/font/Plateia Bold.ttf")
	font.size = 18
	pass


func add_entries(players_array):
	var count = 1
	for i in players_array:
		var label = Label.new()
		label.text = count + ". " + i["username"] + "    " + i["highscore"]
		label.add_font_override("font", font)
		scroll_vbox.add_child(label)
		
