class_name InputBuffer extends Node

###
## InputBuffer is a timed queue of actions that clears after a number of frames.
## You can register sequences of actions to it and it will emit events based on those sequences.
###

@export var input_buffer_frames: int = 10

@onready var timer: Timer = $Timer

signal input_received(action_name: String)

var input_buffer: Array[String] = []
var input_sequences: Dictionary = {} # String, String

func _on_input_received(action_name: String):
	input_buffer.append(action_name)

func _on_timeout_input_buffer():
	input_buffer.clear()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = input_buffer_frames / 60.0
	timer.timeout.connect(_on_timeout_input_buffer)
	input_received.connect(_on_input_received)
