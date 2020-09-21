extends MarginContainer

signal sound_on
signal sound_off
signal start_game
signal open_shop


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_PlayButton_pressed():
	emit_signal("start_game")
	hide()


func _on_shopButton_pressed():
	emit_signal("open_shop")
	hide()
