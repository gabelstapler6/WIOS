extends Area2D

signal hit
signal shoot_bullet
signal ammo_change(player_ammo)

signal rage_mode_on(sec)
signal rage_mode_off

signal inventory_stock_changed(item_name, stock)

# export -> damit man in der godot gui speed anfassen kann Einheit pixel/sec
export var speed = 400
var screen_size

var shooting = false
var ammo = 0
var score = 0

var rage_mode_on = false
var rage_mode_sec
var ammo_save = 0

onready var sprite = $Spaceship
onready var fire = $Spaceship/AnimatedFire
onready var collision_polygon = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	fire.animation = "idle"
	screen_size = get_viewport_rect().size
	hide()
	emit_signal("ammo_change", ammo)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # movement vector
	
	if shooting:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
			
		if PlayerInventory.inventory["VerticalMovementStock"]:
			if Input.is_action_pressed("ui_down"):
				velocity.y += 1
				start_fire_animation()
			elif Input.is_action_pressed("ui_up"):
				velocity.y -= 1
				start_fire_animation()
			else:
				stop_fire_animation()
				
		if Input.is_action_just_pressed("ui_shoot"):
			if ammo > 0:
				ammo -= 1
				emit_signal("shoot_bullet")
				if rage_mode_on == false:
					emit_signal("ammo_change", ammo)
					
		if Input.is_action_just_pressed("ui_use_rage_mode"):
				use_rage_mode()
	
	if velocity.length() > 0:
		# normalize damit bei gleichzeitigem drücken kein Speedboost entsteht
		velocity = velocity.normalized() * speed

	# hier wird mit delta multipliziert damit bei fps drop der speed gleich bleibt
	position += velocity * delta
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func start(pos):
	position = pos
	show()
	collision_polygon.disabled = false

func add_ammo():
	if rage_mode_on == false:
		ammo += PlayerInventory.inventory["AmmoIncreaseStock"]
		emit_signal("ammo_change", ammo)

func use_rage_mode():
	if PlayerInventory.inventory["RageModeStock"] > 0:
		if rage_mode_on == false:
			PlayerInventory.inventory["RageModeStock"] -= 1
			$RageModeTimer.start()
			rage_mode_sec = 0
			ammo_save = ammo
			ammo = 9999999999
			rage_mode_on = true
			emit_signal("inventory_stock_changed", "RageMode", PlayerInventory.inventory["RageModeStock"])
			emit_signal("rage_mode_on", rage_mode_sec)


func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
	
	if rage_mode_on:
		emit_signal("rage_mode_off")
		rage_mode_on = false
	# collision sicher entfernen
	collision_polygon.set_deferred("disabled", true)


func _on_RageModeTimer_timeout():
	if rage_mode_sec == 10:
		emit_signal("rage_mode_off")
		ammo = ammo_save
		emit_signal("ammo_change", ammo)
		rage_mode_on = false
		return
	rage_mode_sec += 1
	$RageModeTimer.start()
	emit_signal("rage_mode_on", rage_mode_sec)


func start_fire_animation():
	fire.animation = "move"
	fire.play()
	
func stop_fire_animation():
	fire.animation = "idle"
	fire.stop()
