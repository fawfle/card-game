class_name DevConsoleNode extends Panel

var _dev_console: DevConsole = DevConsole.new()

@onready var output_label: RichTextLabel = %OutputLabel
@onready var input_line: LineEdit = %InputLine
# Line edit so it's visually the same.
@onready var ghost_text: LineEdit = %GhostText

func _ready() -> void:
	input_line.text_changed.connect(_on_text_changed)
	input_line.text_submitted.connect(_on_input_submit)

func _input(event: InputEvent) -> void:
	if not event is InputEventKey: return
	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed: return
	
	var toggled: bool = key_event.keycode == KEY_QUOTELEFT
	
	if toggled:
		if not visible: show_console()
		else: hide_console()
	elif visible and key_event.keycode == KEY_ESCAPE:
		hide_console()
	
	if key_event.keycode == KEY_UP:
		if _dev_console.has_previous_command():
			input_line.text  = _dev_console.get_previous_command()
			move_cursor_to_end()
		get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_DOWN:
		if _dev_console.has_next_command():
			input_line.text = _dev_console.get_next_command()
			move_cursor_to_end()
		get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_TAB:
		var completions: PackedStringArray = _dev_console.get_completions(input_line.text)
		if completions.size() == 1:
			input_line.text = completions[0]
			move_cursor_to_end()
		get_viewport().set_input_as_handled()

func _on_input_submit(input: String) -> void:
	input_line.clear()
	var result: String = _dev_console.process_command(input)
	output_label.text = result

func _on_text_changed(new_text: String) -> void:
	var completions: PackedStringArray = _dev_console.get_completions(new_text)
	if completions.size() == 1:
		ghost_text.placeholder_text = completions[0]
	else:
		ghost_text.placeholder_text = ""

func show_console():
	visible = true
	input_line.grab_focus.call_deferred()

func hide_console():
	visible = false
	get_viewport().gui_release_focus()

func move_cursor_to_end() -> void:
	await get_tree().process_frame
	input_line.caret_column = input_line.text.length()
