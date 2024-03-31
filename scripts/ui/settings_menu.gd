extends PanelContainer

@onready
var _rtl_text_checkbox: CheckBox = %RTLTextCheckbox

@onready
var _text_speed_input: LineEdit = %TextSpeedInput

@onready
var _apply: Button = %ApplyButton

@onready
var _close_button: Button = %CloseButton

var last_input_text: String = "20"

func _ready() -> void:
	Settings.dialogue_box_settings_changed.connect(_on_dialogue_box_settings_changed)
	_on_dialogue_box_settings_changed(Settings.dialogue_box_settings)
	
	_apply.pressed.connect(_on_apply)
	_text_speed_input.text_changed.connect(_on_text_speed_input_edit)
	
	_text_speed_input.text = str(Settings.dialogue_box_settings.letters_per_second)
	last_input_text = _text_speed_input.text
	
	_close_button.pressed.connect(hide)

func _on_apply() -> void:
	Settings.dialogue_box_settings.letters_per_second = int(_text_speed_input.text)
	Settings.dialogue_box_settings.text_direction_text = Control.TEXT_DIRECTION_RTL if _rtl_text_checkbox.button_pressed else Control.TEXT_DIRECTION_AUTO
	Settings.dialogue_box_settings_changed.emit(Settings.dialogue_box_settings)
	Settings.save_settings()

func _on_text_speed_input_edit(new_text: String) -> void:
	if not new_text.is_valid_int():
		if new_text.is_empty():
			last_input_text = "1"
		_text_speed_input.text = last_input_text
		return
	if int(new_text) <= 0:
		_text_speed_input.text = "1"
	last_input_text = _text_speed_input.text

func _on_dialogue_box_settings_changed(new_settings: DQDialogueBoxSettings) -> void:
	_rtl_text_checkbox.button_pressed = true if new_settings.text_direction_text == Control.TEXT_DIRECTION_RTL else false
	_text_speed_input.text = str(new_settings.letters_per_second)
	last_input_text = _text_speed_input.text
