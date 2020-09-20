extends MarginContainer

signal play_again
signal main_menu
signal save_button_pressed


var first_score = 0
var second_score = 0
var third_score = 0

onready var first_score_label = $VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/FirstScore
onready var second_score_label = $VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/SecondScore
onready var third_score_label = $VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/ThirdScore
onready var highscore_label = $VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/HighScores

# Called when the node enters the scene tree for the first time.
func _ready():
	third_score_label.hide()
	highscore_label.hide()
	pass


func hide():
	$VBoxContainer/CenterScore/ScoreLabel.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/Message.hide()
	$VBoxContainer/AmmoCount.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/PlayAgainButton.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/MainMenuButton.hide()
	first_score_label.hide()
	second_score_label.hide()
	third_score_label.hide()
	highscore_label.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/NameLineEdit.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/SaveScoreButton.hide()
	
func show():
	$VBoxContainer/CenterScore/ScoreLabel.show()
	$VBoxContainer/CenterContainer/VBoxContainer/Message.show()
	$VBoxContainer/AmmoCount.show()

func show_message(text):
	$VBoxContainer/CenterContainer/VBoxContainer/Message.text = text
	$VBoxContainer/CenterContainer/VBoxContainer/Message.show()
	$MessageTimer.start()

func show_game_over():
	$VBoxContainer/CenterContainer/VBoxContainer/Message.text = "Game over"
	$VBoxContainer/CenterContainer/VBoxContainer/Message.show()
	$VBoxContainer/AmmoCount.hide()
	
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/PlayAgainButton.show()
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/MainMenuButton.show()
	
	first_score_label.show()
	second_score_label.show()
	third_score_label.show()
	
	highscore_label.show()
	$VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/NameLineEdit.show()
	$VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/SaveScoreButton.show()

func update_score(score):
	$VBoxContainer/CenterScore/ScoreLabel.text = str(score)
	

func _on_MessageTimer_timeout():
	$VBoxContainer/CenterContainer/VBoxContainer/Message.hide()


func _on_PlayAgainButton_pressed():
	emit_signal("play_again")
	
	first_score_label.hide()
	second_score_label.hide()
	third_score_label.hide()
	
	highscore_label.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/NameLineEdit.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/SaveScoreButton.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/PlayAgainButton.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/MainMenuButton.hide()


func _on_MainMenuButton_pressed():
	emit_signal("main_menu")
	hide()


func _on_Player_rage_mode_on():
	$VBoxContainer/AmmoCount.add_color_override("font_color", "c70000")
	$VBoxContainer/AmmoCount.text = "Ammo: RAGE MODE"


func _on_Player_rage_mode_off():
	$VBoxContainer/AmmoCount.add_color_override("font_color", "ffffff")
	

func _on_Player_ammo_change(player_ammo):
	$VBoxContainer/AmmoCount.text = "Ammo: " + str(player_ammo)


func set_highscore_entry(score):
	if third_score < score:
		if second_score < score:
			if first_score < score:
				third_score_label.text = second_score_label.text
				second_score_label.text = first_score_label.text
				first_score_label.text = $VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/NameLineEdit.text + " " + str(score)
				third_score = second_score
				second_score = first_score
				first_score = score	
							
			else:
				third_score_label.text = second_score_label.text
				second_score_label.text = $VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/NameLineEdit.text + " " + str(score)
				third_score = second_score
				second_score = score
		else:
			third_score_label.text = $VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/NameLineEdit.text + " " + str(score)
			third_score = score


func _on_SaveScoreButton_pressed():
	emit_signal("save_button_pressed")


func is_disabled(value):
	$VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/SaveScoreButton.disabled = value
