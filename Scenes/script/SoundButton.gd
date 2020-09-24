extends MarginContainer

signal sound_off
signal sound_on

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_toggled(button_pressed):
	if button_pressed:
		emit_signal("sound_off")
	else:
		emit_signal("sound_on")
