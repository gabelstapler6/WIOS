extends MarginContainer

signal sound_on
signal sound_off
signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_PlayButton_pressed():
	emit_signal("start_game")
	hide()

