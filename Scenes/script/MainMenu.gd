extends MarginContainer


signal start_game
signal show_highscores

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_PlayButton_pressed():
	emit_signal("start_game")
	hide()



func _on_HighscoreButton_pressed():
	emit_signal("show_highscores")
