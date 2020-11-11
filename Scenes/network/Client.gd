extends Node


class_name WiosClient

var client = WebSocketClient.new()

var websocket_url = "ws://85.214.254.22:9080"
var is_connected_to_host = false
onready var parent = get_parent()

var callback_functions = [
	"register_received",
	"login_received",
	"highscores_received"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	client.connect("connection_closed", self, "_on_closed")
	client.connect("connection_error", self, "_on_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data_received")

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


# server parses through the dictionary and calls the function: name with the arguments
func call_server_function(name, args):
	if is_connected_to_host:
		var server_function = {
			"name": name,
			"args": args
		}
		var json_data = to_json(server_function)
		client.get_peer(1).put_packet(json_data.to_utf8())

# server sends data back in the format:
# data = {
#	"callback_func": some_data
# }
func _on_data_received():
	var pkt = client.get_peer(1).get_packet()
	var string = pkt.get_string_from_utf8()
	var data = parse_json(string)
	
	for callback in callback_functions:
		if data.has(callback):
			parent.call(callback, data[callback])
			return
	
