extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	$AmmoCount.hide()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
	
func show_game_over():
	show_message("Game Over")
	
	# wartet bis der Timer zuende ist
	yield($MessageTimer, "timeout")
	
	$Message.text = "wasted in outta space"
	$Message.show()
	
	$StartButton.show()
	$AmmoCount.hide()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
	

func _on_Message_Timer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
