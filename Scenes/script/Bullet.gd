extends RigidBody2D

var speed = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
