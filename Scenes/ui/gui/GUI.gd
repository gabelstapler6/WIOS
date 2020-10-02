extends Control

signal play_again
signal main_menu

onready var play_again_button = $VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/PlayAgainButton
onready var main_menu_button = $VBoxContainer/CenterContainer/VBoxContainer/MarginContainer/VBoxContainer2/MainMenuButton
onready var ammo_label = $GUI/AmmoCount
onready var my_highscore = $VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer2/MyHighscore
onready var message = $VBoxContainer/CenterContainer/VBoxContainer/Message
onready var score_label = $VBoxContainer/CenterScore/ScoreLabel

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
	message.text = text
	message.show()
	$MessageTimer.start()

func show_game_over():
	$MessageTimer.stop()
	message.text = "Game over"
	message.show()
	ammo_label.hide()
	
	play_again_button.show()
	main_menu_button.show()
	my_highscore.show()

func update_score(score):
	score_label.text = str(score)
	

func _on_MessageTimer_timeout():
	message.hide()


func _on_PlayAgainButton_pressed():
	emit_signal("play_again")


func _on_MainMenuButton_pressed():
	emit_signal("main_menu")
	hide()


func _on_Player_rage_mode_on(sec):
	ammo_label.add_color_override("font_color", "c70000")
	ammo_label.text = "RAGE MODE: " + str(sec)
	
	


func _on_Player_rage_mode_off():
	ammo_label.add_color_override("font_color", "ffffff")
	

func _on_Player_ammo_change(player_ammo):
	ammo_label.text = "AMMO: " + str(player_ammo)
