extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var username_line_edit = $VBox/Margin/VBox/UsernameLineEdit
onready var password_line_edit = $VBox/Margin/VBox/PasswordLineEdit
onready var enter_button = $VBox/Margin/VBox/Center/enterButton

signal enter_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_username():
	return username_line_edit.text
	
func get_password():
	return password_line_edit.text

func _on_enterButton_pressed():
	if username_line_edit.text == "" || password_line_edit.text == "":
		return
	emit_signal("enter_pressed")
