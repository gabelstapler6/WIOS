extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBox/ScoreLabel.text = "SCORE: 0"
	

func update_score(score):
	$VBox/ScoreLabel.text = "SCORE: " + str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
