extends Node


const PORT = 9080

var _server = WebSocketServer.new()

var clients = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_server.connect("client_connected", self, "_on_client_connected")
	_server.connect("client_disconnected", self, "_on_client_disconnected")
	_server.connect("client_close_request", self, "_on_client_close_request")
	_server.connect("data_received", self, "_on_data_received")
	
	var err = _server.listen(PORT)
	if err != OK:
		print("Unable to start Server!")
		set_process(false)


func _process(_delta):
	_server.poll()


func _on_client_connected(id, _proto):
	print("Hello " + id)


func _on_client_disconnected(id, _was_clean = false):
	print("Peace out " + id)


func _on_client_close_request(id, _proto, reason):
	print(id + "tries to disconnect because " + reason)

	
func _on_data_received(id):
	# get the data from the peer
	var pkt = _server.get_peer(id).get_packet()
	var json_data = parse_json(pkt.get_string_from_utf8())

	PlayerData.insert_data(json_data["username"], json_data["score"])

	json_data = to_json(PlayerData.highscore_list)
	
	# send the new highscore-list to the client back
	_server.get_peer(id).put_packet(json_data.to_utf8())