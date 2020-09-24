extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBox/ScoreLabel.text = "Score: 0"
	

func update_score(score):
	$VBox/ScoreLabel.text = "Score: " + str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
