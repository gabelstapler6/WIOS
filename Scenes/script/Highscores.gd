extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var scroll_grid = $VBox/Scroll/Grid
var font
var label_array = []

signal go_back

# Called when the node enters the scene tree for the first time.
func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://Assets/font/Plateia Bold.ttf")
	font.size = 18
	pass


func add_entries(players_array):
	var count = 1
	for i in players_array:
		var number = Label.new()
		var username = Label.new()
		var score = Label.new()
		number.text = str(count) + "."
		username.text = i["username"]
		score.text = str(i["highscore"])

		number.add_font_override("font", font)
		username.add_font_override("font", font)
		score.add_font_override("font", font)
		
		label_array.append(number)
		label_array.append(username)
		label_array.append(score)
		
		scroll_grid.add_child(number)
		scroll_grid.add_child(username)
		scroll_grid.add_child(score)
		count += 1
		


func _on_BackButton_pressed():
	emit_signal("go_back")
	for i in label_array:
		i.queue_free()
	label_array.clear()
