extends MarginContainer

signal play_again
signal main_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func hide():
	$VBoxContainer/CenterScore/ScoreLabel.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/Message.hide()
	$VBoxContainer/AmmoCount.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/PlayAgainButton.hide()
	$VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/MainMenuButton.hide()
	
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

func update_score(score):
	$VBoxContainer/CenterScore/ScoreLabel.text = str(score)
	

func _on_MessageTimer_timeout():
	$VBoxContainer/CenterContainer/VBoxContainer/Message.hide()


func _on_PlayAgainButton_pressed():
	emit_signal("play_again")
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
