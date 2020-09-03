extends Area2D

signal hit


# export -> damit man in der godot gui speed anfassen kann Einheit pixel/sec
export var speed = 400
var screen_size

var level_up = false



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # movement vector

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		
	if level_up == true:
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
	
	if velocity.length() > 0:
		# normalize damit bei gleichzeitigem drücken keine Speedboost entsteht
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	# hier wird mit delta multipliziert damit bei fps drop der speed gleich bleibt
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
	# collision sicher entfernen
	$CollisionShape2D.set_deferred("disabled", true)
