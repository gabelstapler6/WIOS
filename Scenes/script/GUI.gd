extends MarginContainer

signal play_again
signal main_menu



onready var play_again_button = $VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/PlayAgainButton
onready var main_menu_button = $VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/MainMenuButton
onready var ammo_label = $VBoxContainer/AmmoCount
onready var my_highscore = $VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer2/MyHighscore
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func show_ingame_hud():
	show()
	ammo_label.show()
	play_again_button.hide()
	main_menu_button.hide()
	my_highscore.hide()
	

func show_message(text):
	$VBoxContainer/CenterContainer/VBoxContainer/Message.text = text
	$VBoxContainer/CenterContainer/VBoxContainer/Message.show()
	$MessageTimer.start()

func show_game_over():
	$VBoxContainer/CenterContainer/VBoxContainer/Message.text = "Game over"
	$VBoxContainer/CenterContainer/VBoxContainer/Message.show()
	ammo_label.hide()
	
	play_again_button.show()
	main_menu_button.show()
	my_highscore.show()

func update_score(score):
	$VBoxContainer/CenterScore/ScoreLabel.text = str(score)
	

func _on_MessageTimer_timeout():
	$VBoxContainer/CenterContainer/VBoxContainer/Message.hide()


func _on_PlayAgainButton_pressed():
	emit_signal("play_again")


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
