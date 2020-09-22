extends Node

var vertical_movement = false
var stock_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init(dict):
	for key in dict:
		stock_dict[key] = dict[key]
	
