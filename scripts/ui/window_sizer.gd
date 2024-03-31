extends Node

@export
var _main_screen: Control

func _ready() -> void:
	get_window().size = _main_screen.size
