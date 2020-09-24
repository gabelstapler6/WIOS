extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main_menu = $MainMenu
onready var login_view = $LoginView
onready var player_score_tag = $PlayerScoreBalance
onready var version_tag = $VersionTag
onready var shop = $Shop
onready var gui = $GUI
onready var shop_button = $ShopButton
onready var sound_button = $SoundButton

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	$GUI.hide()
	$Shop.hide()
	$MainMenu.hide()
	$ShopButton.hide()
	$PlayerScoreBalance.hide()



func _on_Shop_go_back():
	$PlayerScoreBalance.show()
	$MainMenu.show()


func _on_SoundButton_sound_off():
	$Music.stop()


func _on_SoundButton_sound_on():
	$Music.play()


func _on_ShopButton_open_shop():
	$GUI.hide()
	$MainMenu.hide()
	$Shop.show()


func setup_gui():
	$LoginView.hide()
	$MainMenu.show()
	$PlayerScoreBalance.show()
	$ShopButton.show()

func update_score(score):
	gui.update_score(score)

func update_score_tag(score):
	player_score_tag.update_score(score)
	
func start_game():
	version_tag.hide()
	gui.show_ingame_hud()
	shop_button.hide()
	player_score_tag.hide()
	gui.show_message("Get Ready")
	
func show_game_over():
	gui.show_game_over()
	version_tag.show()
	shop_button.show()
	
func show_message(message):
	gui.show_message(message)


func get_username():
	return login_view.get_username()
	
func get_password():
	return login_view.get_password()
