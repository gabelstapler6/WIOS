extends MarginContainer

signal sound_on
signal sound_off
signal start_game

export var version = 1.3


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/VersionLabel.text = "v" + str(version)


func update_score(player_score):
	$VBoxContainer/HBoxTopBar/scoreLabel.text = "score: " + str(player_score)

func _on_SoundButton_toggled(button_pressed):
	if button_pressed:
		emit_signal("sound_off")
	else:
		emit_signal("sound_on")


func _on_PlayButton_pressed():
	emit_signal("start_game")
	hide()
