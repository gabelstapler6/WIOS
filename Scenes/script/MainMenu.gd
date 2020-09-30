extends MarginContainer


signal start_game
signal show_highscores
signal show_how_to_play
# signal change_user

onready var popup = $VBox/Center/Popup
onready var welcome_label = $VBox/WelcomeLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_PlayButton_pressed():
	emit_signal("start_game")
	hide()


# func _on_HighscoreButton_pressed():
# 	emit_signal("show_highscores")


# func _on_ChangeUser_pressed():
# 	emit_signal("change_user")


func _on_HighscoresButton_pressed():
	emit_signal("show_highscores")


func _on_HowToButton_pressed():
	emit_signal("show_how_to_play")
