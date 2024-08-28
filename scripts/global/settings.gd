extends Node
class_name AppSettings

const SETTINGS_FILE_PATH := &"user://settings.conf"
const CACHE_FILE_PATH := &"user://cache"

signal dialogue_box_settings_changed(new_settings: DQDialogueBoxSettings)

var dialogue_box_settings: DQDialogueBoxSettings = preload("res://addons/dialogue_quest/resources/components/settings/default_dialogue_box_settings.tres") :
	set(value):
		dialogue_box_settings = value
		dialogue_box_settings_changed.emit(value)

func _ready() -> void:
	reload_settings()

func save_settings() -> void:
	var cf := ConfigFile.new()
	
	cf.set_value("Text", "speed", dialogue_box_settings.letters_per_second)
	cf.set_value("Layout", "text_direction", dialogue_box_settings.text_direction_text)
	
	cf.save(SETTINGS_FILE_PATH)

func save_to_cache(key: String, value: Variant) -> void:
	var cf := ConfigFile.new()
	
	if FileAccess.file_exists(CACHE_FILE_PATH):
		cf.load(CACHE_FILE_PATH)
	
	cf.set_value("Cache", key, value)
	
	cf.save(CACHE_FILE_PATH)

func reload_settings() -> void:
	var cf := ConfigFile.new()
	
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		save_settings()
	
	cf.load(SETTINGS_FILE_PATH)
	
	dialogue_box_settings.letters_per_second = cf.get_value("Text", "speed", dialogue_box_settings.letters_per_second)
	dialogue_box_settings.text_direction_text = cf.get_value("Layout", "text_direction", dialogue_box_settings.text_direction_text)
	dialogue_box_settings_changed.emit(dialogue_box_settings)

func get_from_cache(key: String, default: Variant = null) -> Variant:
	var cache := ConfigFile.new()
	if not FileAccess.file_exists(CACHE_FILE_PATH):
		return default
	cache.load(CACHE_FILE_PATH)
	return cache.get_value("Cache", key, default)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()
