class_name DevConsoleNode extends Panel

var _dev_console: DevConsole = DevConsole.new()

@onready var output_label: RichTextLabel = %OutputLabel
@onready var input_line: LineEdit = %InputLine

func _ready() -> void:
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
		pass

func _on_input_submit(input: String) -> void:
	input_line.clear()
	var result: String = _dev_console.process_command(input)
	output_label.text = result

func show_console():
	visible = true
	input_line.grab_focus.call_deferred()

func hide_console():
	visible = false
	get_viewport().gui_release_focus()
