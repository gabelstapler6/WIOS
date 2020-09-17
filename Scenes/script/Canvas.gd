extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	$GUI.hide()
	$Shop.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MainMenu_open_shop():
	$Shop.show()


func _on_Shop_go_back():
	$MainMenu.show()


func _on_SoundButton_sound_off():
	$Music.stop()


func _on_SoundButton_sound_on():
	$Music.play()
