extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
	
func show_game_over():
	show_message("Game Over")
	
	# wartet bis der Timer zuende ist
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the Tiles!"
	$Message.show()
	
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
	

func _on_Message_Timer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
