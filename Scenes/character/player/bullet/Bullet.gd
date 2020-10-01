extends RigidBody2D

class_name Bullet

var speed = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_Area2D_body_entered(_body):
	queue_free()
