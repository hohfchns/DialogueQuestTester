extends PanelContainer

@onready
var _close_button: Button = %CloseButton

@onready
var _id_input: LineEdit = %IdInput

@onready
var _name_input: LineEdit = %NameInput

@onready
var _color_input: ColorPickerButton = %ColorInput

@onready
var _portrait_browse_button: Button = %PortraitBrowseButton
@onready
var _portrait_file_dialog: FileDialog = %PortraitFileDialog
@onready
var _portrait_path_input: LineEdit = %PortraitPathInput

@onready
var _create_button: Button = %CreateButton

var portrait_file: String = ""

func _ready() -> void:
	_portrait_browse_button.pressed.connect(_portrait_file_dialog.popup)
	_portrait_file_dialog.file_selected.connect(_on_portrait_file_selected)
	
	_close_button.pressed.connect(hide)
	
	_create_button.pressed.connect(_on_create_button_press)
	
	_portrait_file_dialog.size = get_window().size * 0.9

func _on_portrait_file_selected(file: String) -> void:
	_portrait_path_input.text = file.get_file()
	portrait_file = file

func _on_create_button_press() -> void:
	var path := DialogueQuest.Settings.data_directory.path_join(_id_input.text + ".tres")
	var dir := path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		printerr("Can't create character. Please set data directory.")
		return
	
	if not _id_input.text:
		return
	if not _name_input.text:
		return
	var portrait = null
	if not portrait_file.is_empty():
		portrait = ImageTexture.create_from_image(Image.load_from_file(portrait_file))
	
	var character := DQCharacter.new()
	character.character_id = _id_input.text
	character.character_name = _name_input.text
	character.color = _color_input.color
	character.portrait = portrait
	
	ResourceSaver.save(character, path)
	
	hide()
