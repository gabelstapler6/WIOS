extends MarginContainer


export var version = "1.4.1"
signal  show_credits

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBox/VersionLabel.text = "v" + version





func _on_CreditButton_pressed():
	emit_signal("show_credits")
