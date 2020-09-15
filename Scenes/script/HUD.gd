extends CanvasLayer

signal start_game



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func hide():
	$ScoreLabel.hide()
	$Message.hide()
	$AmmoCount.hide()
	
func show():
	$ScoreLabel.show()
	$Message.show()
	$AmmoCount.show()
	

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# wartet bis der Timer zuende ist
	#yield($MessageTimer, "timeout")
	#$Message.text = "wasted in outta space"
	#$Message.show()
	#$AmmoCount.hide()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	

func _on_Message_Timer_timeout():
	$Message.hide()

