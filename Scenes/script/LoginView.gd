extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var username_line_edit = $VBox/Margin/VBox/UsernameLineEdit
onready var enter_button = $VBox/Margin/VBox/Center/enterButton
onready var add_button = $VBox/Margin/VBox/Center/HBoxContainer/AddUser
onready var popup = $VBox/Margin/VBox/Center/FailedLogin

signal enter_pressed
signal add_user_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_username():
	return username_line_edit.text

func is_empty():
	if username_line_edit.text == "":
		return true

func _on_enterButton_pressed():
	if not is_empty():
		emit_signal("enter_pressed")


func _on_AddUser_pressed():
	if not is_empty():
		emit_signal("add_user_pressed")
