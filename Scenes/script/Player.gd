extends Area2D

signal hit
signal shoot_bullet
signal ammo_change(player_ammo)

signal rage_mode_on
signal rage_mode_off

signal inventory_stock_changed(item_name, stock)

# export -> damit man in der godot gui speed anfassen kann Einheit pixel/sec
export var speed = 400
var screen_size

var shooting = false
var ammo = 0
var score = 0

var rage_mode_on = false
var ammo_save = 0

onready var inventory = $PlayerInventory

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	emit_signal("ammo_change", ammo)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # movement vector

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		
	if inventory.vertical_movement:
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
	
	if shooting:
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
	$CollisionShape2D.disabled = false

func add_ammo():
	if rage_mode_on == false:
		ammo += inventory.stock_dict["AmmoIncrease_stock"]
		emit_signal("ammo_change", ammo)

func use_rage_mode():
	if inventory.stock_dict["RageMode_stock"] > 0:
		if rage_mode_on == false:
			inventory.stock_dict["RageMode_stock"] -= 1
			$RageModeTimer.start()
			ammo_save = ammo
			ammo = 9999999999
			rage_mode_on = true
			emit_signal("inventory_stock_changed", "RageMode", inventory.stock_dict["RageMode_stock"])
			emit_signal("rage_mode_on")


func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
	
	if rage_mode_on:
		emit_signal("rage_mode_off")
		rage_mode_on = false
	# collision sicher entfernen
	$CollisionShape2D.set_deferred("disabled", true)


func _on_RageModeTimer_timeout():
	emit_signal("rage_mode_off")
	ammo = ammo_save
	emit_signal("ammo_change", ammo)
	rage_mode_on = false

func vertical_movement_enabled():
	if inventory.stock_dict["VerticalMovement_stock"] > 0:
		inventory.vertical_movement = true
