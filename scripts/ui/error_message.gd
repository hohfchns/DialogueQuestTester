extends Control

@onready
var _error_text: Label = %ErrorText

@onready
var _ok_button: Button = %OkButton

func _ready():
	_ok_button.pressed.connect(hide)
	
	DialogueQuest.error.connect(_on_error)

func _on_error(message: String) -> void:
	_error_text.text = message
	show()
