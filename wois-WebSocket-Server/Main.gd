extends Node

const PORT = 9080

var _server = WebSocketServer.new()

var backup_path = "user://backup.save"


# Called when the node enters the scene tree for the first time.
func _ready():
	_server.connect("client_connected", self, "_on_client_connected")
	_server.connect("client_disconnected", self, "_on_client_disconnected")
	_server.connect("client_close_request", self, "_on_client_close_request")
	_server.connect("data_received", self, "_on_data_received")
	
	load_backup()
	
	
	var err = _server.listen(PORT)
	if err != OK:
		print("Unable to start Server!")
		set_process(false)
	

func _process(_delta):
	_server.poll()


func _on_client_connected(id, _proto):
	print("Hello ", id)


func _on_client_disconnected(id, _was_clean = false):
	print("Peace out ", id)


func _on_client_close_request(id, _proto, reason):
	print(id, " tries to disconnect, reason: ", reason)


func get_highscore_list(args):
	var packet = {
		"highscores_callback": PlayerData.highscore_list
	}
	var json_data = to_json(packet)
	# send the new highscore-list to the client back
	_server.get_peer(args["id"]).put_packet(json_data.to_utf8())

func post_highscore(arg):
	PlayerData.insert_highscore(arg["username"], arg["score"])
	save()

func register_user(arg):
	var value = false
	
	if PlayerData.user_list.has_key(arg["username"]):
		value = true
	
	var packet = {
		"register_callback": value
	}
	var json_data = to_json(packet)
	_server.get_peer(arg["id"]).put_packet(json_data.to_utf8())
	
	if not value:
		PlayerData[arg["username"]] = arg["password"]
		var save = File.new()
		# save changes to server backup
		save()


func login_user(arg):
	var value = false
	var data = {}
	if PlayerData.user_list.has_key(arg["username"]):
		if PlayerData.user_list[arg["username"]] == arg["password"]:
			value = true
			data["game_save"] = get_user_game_save(arg["username"])
			
	data["correct"] = value
	var packet = {
		"login_callback": data
	}
	var json_data = to_json(packet)
	_server.get_peer(arg["id"]).put_packet(json_data.to_utf8())	


func get_user_game_save(username):
	var save = File.new()
	if not save.file_exists("user://" + username + "_save.save"):
		return {}
	
	save.open("user://" + username + "_save.save", File.READ)
	
	var node_data
	while save.get_position() < save.get_len():
		node_data = parse_json(save.get_line())
		
	return node_data

func _on_data_received(id):
	# get the data from the peer
	var pkt = _server.get_peer(id).get_packet()
	var string = pkt.get_string_from_utf8()
	var dict = parse_json(string)
	dict["id"] = id
	call(dict["name"], dict["args"])
	
	
func save():
	var backup = File.new()
	backup.open(backup_path, File.WRITE)
	backup.store_line(to_json(PlayerData.highscore_list))
	backup.store_line(to_json(PlayerData.user_list))
	backup.close()
	
func load_backup():
	var backup = File.new()
	
	if not backup.file_exists(backup_path):
		return
	backup.open_encrypted_with_pass(backup_path, File.READ, OS.get_unique_id())
	
	PlayerData.highscore_list = parse_json(backup.get_line())
	PlayerData.user_list = parse_json(backup.get_line())
	
	backup.close()
