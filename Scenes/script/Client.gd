extends Node


class_name WiosClient

var client = WebSocketClient.new()

var websocket_url = "ws://and1dev.space:9080"
var is_connected_to_host = false
signal data_arrived(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	client.connect("connection_closed", self, "_on_closed")
	client.connect("connection_error", self, "_on_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")

	var err = client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect!")
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	client.poll()


func _on_closed(was_clean = false):
	print("Connected to Server: ", was_clean)
	set_process(false)

func _on_connected(proto = ""):
	is_connected_to_host = true
	print("Connected with protocol: ", proto)


func post_highscore(username, score):
	if is_connected_to_host:
		var dict = {
			"username": username,
			"score": score 
		}
		var json_data = to_json(dict)
		
		client.get_peer(1).put_packet(json_data.to_utf8())


func retrieve_highscore_list():
	if is_connected_to_host:
		client.get_peer(1).put_packet("get_highscore_list".to_utf8())


func _on_data():
	var pkt = client.get_peer(1).get_packet()
	var string = pkt.get_string_from_utf8()
	var data = parse_json(string)
	emit_signal("data_arrived", data)

	
