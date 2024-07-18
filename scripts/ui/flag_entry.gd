@tool
extends Control

enum VarMode {
	BOOLEAN = 0,
	STRINGLIKE,
	NUMBER,
	UNRECOGNIZED
}

signal delete_requested(identifier: String)
signal edited(identifier: String, value: Variant)

@export
var var_mode: VarMode = VarMode.BOOLEAN :
	set(value):
		var_mode = value
		var modes := _edit_root.get_children()
		for n in modes:
			n.hide()
		modes[int(value)].show()
	get:
		return var_mode

@export
var identifier: String :
	set(value):
		if not _identifier and not is_node_ready():
			identifier = value
			await ready
		_identifier.text = value
	get:
		if not _identifier and not is_node_ready():
			return identifier
		return _identifier.text

@export
var boolean: bool :
	set(value):
		if not _edit_boolean and not is_node_ready():
			boolean = value
			await ready
		
		_edit_boolean.set_pressed_no_signal(value)
	get:
		if not _edit_boolean and not is_node_ready():
			return boolean
		return _edit_boolean.is_pressed()

@export
var stringlike: String :
	set(value):
		if not _edit_stringlike and not is_node_ready():
			stringlike = value
			await ready
		_edit_stringlike.text = value
	get:
		if not _edit_stringlike and not is_node_ready():
			return stringlike
		return _edit_stringlike.text

@export
var number: float :
	set(value):
		if not _edit_number and not is_node_ready():
			number = value
			await ready
		
		_edit_number.text = str(value)
	get:
		if not _edit_number and not is_node_ready():
			return number
		return float(_edit_number.text)

@export
var unrecognized: String :
	set(value):
		if not _edit_unrecognized and not is_node_ready():
			unrecognized = value
			await ready
		_edit_unrecognized.text = value
	get:
		if not _edit_unrecognized and not is_node_ready():
			return unrecognized
		return _edit_unrecognized.text

@onready
var _edit_root: Container = %Edit

@onready
var _identifier: Label = %Identifier

@onready
var _edit_boolean: CheckButton = %EditBoolean

@onready
var _edit_stringlike: LineEdit = %EditStringlike

@onready
var _edit_number: LineEdit = %EditNumberText

@onready
var _edit_unrecognized: LineEdit = %EditUnrecognized

@onready
var _number_up_button: BaseButton = %EditNumberUp

@onready
var _number_down_button: BaseButton = %EditNumberDown

@onready
var _delete_button: BaseButton = %DeleteButton

func _ready():
	_number_up_button.pressed.connect(
		func():
			number += 1
			edited.emit(identifier, number)
	)
	_number_down_button.pressed.connect(
		func():
			number -= 1
			edited.emit(identifier, number)
	)
	
	_delete_button.pressed.connect(
		func():
			delete_requested.emit(identifier)
	)
	
	_edit_boolean.toggled.connect(
		func():
			edited.emit(identifier, boolean)
	)
	
	_edit_number.text_submitted.connect(
		func():
			edited.emit(identifier, number)
	)
	
	_edit_stringlike.text_submitted.connect(
		func():
			edited.emit(identifier, stringlike)
	)
	
	_edit_number.focus_exited.connect(
		func():
			_edit_number.text_submitted.emit()
	)
	
	_edit_stringlike.focus_exited.connect(
		func():
			_edit_stringlike.text_submitted.emit()
	)

func fill_data(flag_identifier: String, variable_mode: VarMode, bool_value: bool = false, stringlike_value: String = "", number_value: float = 0.0) -> void:
	var_mode = variable_mode
	identifier = flag_identifier
	boolean = bool_value
	stringlike = stringlike_value
	number = number_value

func fill(flag_identifier: String) -> void:
	var value: Variant = DialogueQuest.Flags.get_flag(flag_identifier)
	identifier = flag_identifier
	if value is bool:
		var_mode = VarMode.BOOLEAN
		boolean = value
	elif value is String or value is StringName or value is NodePath:
		var_mode = VarMode.STRINGLIKE
		stringlike = str(value)
	elif value is int or value is float:
		var_mode = VarMode.NUMBER
		number = value
	else:
		var_mode = VarMode.UNRECOGNIZED
		stringlike = str(value)
