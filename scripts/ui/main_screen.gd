extends PanelContainer

@onready
var _dir_input: LineEdit = %DialogueQuestDirInput
@onready
var _dir_browse_btn: Button = %DialogueQuestDirBrowse
@onready
var _dir_dialog: FileDialog = %DialogueQuestDirDialog

@onready
var _dialogue_input: LineEdit = %DialogueInput
@onready
var _dialogue_input_browse: MenuButton = %DialogueInputBrowse

@onready
var _create_character_btn: Button = %CreateCharacterButton

@onready
var _create_character_menu: Control = %CreateCharacterMenu

@onready
var _settings_btn: Button = %SettingsButton

@onready
var _settings_menu: Control = %SettingsMenu

@onready
var _run_button: Button = %RunButton

@onready
var _dialogue_player: DQDialoguePlayer = %DialoguePlayer

@onready
var _dialogue_box: DQDialogueBox = %DialogueBox

func _ready() -> void:
	_dir_browse_btn.pressed.connect(_dir_dialog.popup)
	_dir_dialog.dir_selected.connect(_on_dir_selected)
	
	_dir_input.text_submitted.connect(_on_dir_submitted)
	
	_dialogue_input_browse.get_popup().index_pressed.connect(_on_dialogue_browse_index_pressed)
	
	_create_character_btn.pressed.connect(_create_character_menu.show)
	_settings_btn.pressed.connect(_settings_menu.show)
	
	_run_button.pressed.connect(_on_run)
	
	_dialogue_box.settings = Settings.dialogue_box_settings
	Settings.dialogue_box_settings_changed.connect(_on_dialogue_box_settings_changed)
	
	_dir_input.text = Settings.get_from_cache("directory_input", "")
	if _dir_input.text.is_empty():
		_dir_input.text = OS.get_user_data_dir()
	
	_dir_input.text_submitted.emit(_dir_input.text)
	
	_dir_dialog.size = size
	_dir_dialog.size.y -= (size.y / 10)

func _on_dir_selected(dir: String) -> void:
	_dir_input.text = dir
	_dir_input.text_submitted.emit(dir)

func _on_dir_submitted(dir: String):
	DialogueQuest.Settings.data_directory = dir
	if not DirAccess.dir_exists_absolute(dir):
		return
	for i in _dialogue_input_browse.get_popup().item_count:
		_dialogue_input_browse.get_popup().remove_item(0)
	var dialogues := DQFilesystemHelper.get_all_files(dir, "dqd")
	for d in dialogues:
		_dialogue_input_browse.get_popup().add_item(d)
	
	Settings.save_to_cache("directory_input", dir)

func _on_dialogue_browse_index_pressed(idx: int) -> void:
	_on_dialogue_chosen(_dialogue_input_browse.get_popup().get_item_text(idx))

func _on_dialogue_chosen(dialogue: String) -> void:
	_dialogue_input.text = dialogue

func _on_run() -> void:
	_dialogue_player.play(_dialogue_input.text)

func _on_dialogue_box_settings_changed(new_settings: DQDialogueBoxSettings) -> void:
	_dialogue_box.settings = new_settings
