extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var text_font
var button_font


# Called when the node enters the scene tree for the first time.
func _ready():
	text_font = DynamicFont.new()
	text_font.font_data = load("res://Assets/font/RussoOne-Regular.ttf")
	text_font.size = 18
	text_font.extra_spacing_char = 3
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
