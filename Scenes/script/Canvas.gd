extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	$GUI.hide()
	$Shop.hide()
	$MainMenu.hide()
	$ShopButton.hide()
	$PlayerScoreBalance.hide()


func _on_Shop_go_back():
	$MainMenu.show()


func _on_SoundButton_sound_off():
	$Music.stop()


func _on_SoundButton_sound_on():
	$Music.play()


func _on_ShopButton_open_shop():
	$GUI.hide()
	$MainMenu.hide()
	$Shop.show()


func _on_LoginView_enter_pressed():
	$LoginView.hide()
	$MainMenu.show()
	$PlayerScoreBalance.show()
	$ShopButton.show()
