extends MarginContainer


export var version = "1.4.1"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBox/VersionLabel.text = "v" + version


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
