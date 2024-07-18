extends Control

const FLAGS_ENTRY_SCENE: PackedScene = preload("res://prefabs/ui/flag_entry.tscn")

@onready
var _flags_container: Container = %FlagsContainer

@onready
var _close_button: Button = %CloseButton

func _ready():
	DialogueQuest.Flags.set_flag("test", 0.5)
	DialogueQuest.Flags.set_flag("test2", "5gksldj")
	DialogueQuest.Flags.set_flag("test3", false)
	DialogueQuest.Flags.raise_flag("test4")
	
	visibility_changed.connect(
		func():
			if visible:
				_refresh_flags()
	)
	
	_close_button.pressed.connect(hide)
	
	hide()

func _refresh_flags() -> void:
	for e in _flags_container.get_children():
		_flags_container.remove_child(e)
		e.queue_free()
	
	var i := 0
	for f in DialogueQuest.Flags.flag_registry.keys():
		var separator := HSeparator.new()
		_flags_container.add_child(separator)
		var entry := FLAGS_ENTRY_SCENE.instantiate()
		entry.delete_requested.connect(_on_entry_delete_requested, CONNECT_ONE_SHOT)
		entry.edited.connect(_on_entry_edited)
		_flags_container.add_child(entry)
		entry.fill(f)
		i += 1

func _on_entry_delete_requested(identifier: String) -> void:
	DialogueQuest.Flags.delete_flag(identifier)
	_refresh_flags()

func _on_entry_edited(identifier: String, value: Variant) -> void:
	DialogueQuest.Flags.set_flag(identifier, value)
