extends MarginContainer


onready var warning_label = $VBox/VBox/WarningLabel
onready var username_line_edit = $VBox/VBox/Margin/VBox/UsernameLineEdit
onready var password_line_edit = $VBox/VBox/Margin/VBox/PasswordLineEdit
onready var login_button = $VBox/VBox/Margin/VBox/Center/HBox/LoginButton
onready var register_button = $VBox/VBox/Margin/VBox/Center/HBox/RegisterButton

signal login(username, password)
signal register(username, password)

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

var username = ""
var password = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func validate_input():
	warning_label.text = ""
	var data = [username_line_edit.text, password_line_edit.text]
	var c = 0
	for text in data:
		var curr_field
		if c == 0:
			curr_field = "username"
		else:
			curr_field = "password"
			
		if text.empty():
			warning_label.text = "your " + curr_field + " cannot be empty"
			return false
		for i in text:
			for special in special_chars:
				if i == special:
					warning_label.text = "you can only use numbers and letters for your " + curr_field
					return false
		c += 1
	return true

func _on_LoginButton_pressed():
	if validate_input():
		emit_signal("login", username_line_edit.text, password_line_edit.text)


func _on_RegisterButton_pressed():
	if validate_input():
		emit_signal("register", username_line_edit.text, password_line_edit.text)


func show_warning_message(message):
	warning_label.text = message
