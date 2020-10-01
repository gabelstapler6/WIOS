extends MarginContainer


onready var warning_label = $VBox/VBox/WarningLabel
onready var line_edit = $VBox/VBox/Margin/VBox/LineEdit
onready var save_button = $VBox/VBox/Margin/VBox/Margin/SaveButton

signal save_username(username)

var special_chars = [
	" ",
	"!",
	"^",
	"§",
	"$",
	"\"",
	"%",
	"&",
	"/",
	"(",
	")",
	"=",
	"{",
	"}",
	"[",
	"]",
	"\\",
	"?",
	"*",
	"+",
	"~",
	"'",
	"#",
	",",
	";",
	":",
	"_",
	"-",
	"Ä",
	"ä",
	"Ö",
	"ö",
	"Ü",
	"ü",
	"ß",
	"µ",
	">",
	"<",
	"|",
	"′",
	"`"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SaveButton_pressed():
	warning_label.text = ""
	var text = line_edit.text
	if text.empty():
		warning_label.text = "your username cannot be empty"
		return
	for i in text:
		for special in special_chars:
			if i == special:
				warning_label.text = "you can only use numbers and letters for your username"
				return
				
	emit_signal("save_username", text)
