extends RigidBody2D

export var min_speed = 150
export var max_speed = 250

onready var sprite = $Sprite
onready var collision_shape = $CollisionPolygon2D
onready var visibility = $VisibilityNotifier2D
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var sprite_scale = sprite.get_scale()
	var coll_scale = collision_shape.get_scale()
	var vis_scale = visibility.get_scale()
	
	# scale variety
	var rn = rand_range(0.5, 1.5)
	sprite.set_scale(sprite_scale*rn)
	collision_shape.set_scale(coll_scale*rn)
	visibility.set_scale(vis_scale*rn)
	
	# rotation variety
	rn = randi() % 360
	set_rotation_degrees(rn)
	
	rn = rand_range(0.3, 0.6)
	
	sprite.set_modulate(Color(rn, rn, rn, 1))
	
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
