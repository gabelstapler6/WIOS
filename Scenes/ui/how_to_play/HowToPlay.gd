extends MarginContainer

signal go_back

onready var text = $Margin/RichText
onready var tween = $Tween
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("go_back")


func _on_HowToPlay_visibility_changed():
	tween.interpolate_property($Margin/RichText, "percent_visible", 0, 1, 10)
