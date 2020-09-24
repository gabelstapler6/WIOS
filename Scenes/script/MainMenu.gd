extends MarginContainer


signal start_game
signal show_highscores
signal change_user

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_PlayButton_pressed():
	emit_signal("start_game")
	hide()


func _on_HighscoreButton_pressed():
	emit_signal("show_highscores")


func _on_ChangeUser_pressed():
	emit_signal("change_user")
