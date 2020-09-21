extends Area2D

signal hit
signal shoot_bullet
signal ammo_change(player_ammo)

signal update_shop_stock(rage_stock, ammo_stock, vertical_stock)
signal update_shop_price(rage_price, ammo_price, vertical_price)

signal vertical_movement_bought

signal rage_mode_on
signal rage_mode_off

signal not_enough_cash_mf
signal update_score(score)

# export -> damit man in der godot gui speed anfassen kann Einheit pixel/sec
export var speed = 400
var screen_size

var shooting = false
var ammo = 0
var score = 0

var rage_mode_on = false
var ammo_save = 0


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
		
	if $PlayerInventory.vertical_movement:
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
		ammo += $PlayerInventory.ammo_increase_stock
		emit_signal("ammo_change", ammo)

func use_rage_mode():
	if $PlayerInventory.rage_mode_stock > 0:
		if rage_mode_on == false:
			$PlayerInventory.rage_mode_stock -= 1
			$RageModeTimer.start()
			ammo_save = ammo
			ammo = 9999999999
			rage_mode_on = true
			update_shop_stock($PlayerInventory.rage_mode_stock, $PlayerInventory.ammo_increase_stock, $PlayerInventory.vertical_movement_stock)
			emit_signal("rage_mode_on")

func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
	
	if rage_mode_on:
		emit_signal("rage_mode_off")
		rage_mode_on = false
	# collision sicher entfernen
	$CollisionShape2D.set_deferred("disabled", true)


func _on_Shop_buy_vertical_movement():
	if $PlayerInventory/Items.vertical_movement_price <= score:
		score -= $PlayerInventory/Items.vertical_movement_price
		$PlayerInventory.vertical_movement = true
		$PlayerInventory.vertical_movement_stock = 1
		update_shop_stock($PlayerInventory.rage_mode_stock, $PlayerInventory.ammo_increase_stock, $PlayerInventory.vertical_movement_stock)
		emit_signal("update_score", score)
		emit_signal("vertical_movement_bought")
	else:
		emit_signal("not_enough_cash_mf")

func _on_Shop_buy_rage_mode():
	if $PlayerInventory/Items.rage_mode_price <= score:
		score -= $PlayerInventory/Items.rage_mode_price
		$PlayerInventory.rage_mode_stock += 1
		update_shop_stock($PlayerInventory.rage_mode_stock, $PlayerInventory.ammo_increase_stock, $PlayerInventory.vertical_movement_stock)
		emit_signal("update_score", score)
	else:
		emit_signal("not_enough_cash_mf")


func _on_RageModeTimer_timeout():
	emit_signal("rage_mode_off")
	ammo = ammo_save
	emit_signal("ammo_change", ammo)
	rage_mode_on = false


func _on_Shop_buy_ammo_increase():
	if $PlayerInventory/Items.ammo_increase_price <= score:
		score -= $PlayerInventory/Items.ammo_increase_price
		$PlayerInventory.ammo_increase_stock += 1
		$PlayerInventory/Items.ammo_increase_price += 1000
		
		update_shop_stock($PlayerInventory.rage_mode_stock, $PlayerInventory.ammo_increase_stock, $PlayerInventory.vertical_movement_stock)
		update_shop_price($PlayerInventory/Items.rage_mode_price, $PlayerInventory/Items.ammo_increase_price, $PlayerInventory/Items.vertical_movement_price)
		
		emit_signal("update_score", score)
	else:
		emit_signal("not_enough_cash_mf")


func update_shop_stock(rage_stock, ammo_stock, vertical_stock):
	emit_signal("update_shop_stock", rage_stock, ammo_stock, vertical_stock)


func update_shop_price(rage_price, ammo_price, vertical_price):
	emit_signal("update_shop_price", rage_price, ammo_price, vertical_price)
