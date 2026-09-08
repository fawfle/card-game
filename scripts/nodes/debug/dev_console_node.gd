class_name DevConsoleNode extends Panel

var _dev_console: DevConsole = null

@onready var output_label: RichTextLabel = %OutputLabel
@onready var input_line: LineEdit = %InputLine
# Line edit so it's visually the same.
@onready var ghost_text: LineEdit = %GhostText

func _ready() -> void:
	# set in ready since DevConsole performs initialization when being created
	_dev_console = DevConsole.new()
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
	
	if key_event.keycode == KEY_TAB or (key_event.keycode == KEY_RIGHT and not key_event.alt_pressed):
		var completion_results: CompletionResults = _dev_console.get_completions(input_line.text)
		var completion: String = completion_results.get_best_completion()
		if completion:
			input_line.text = completion
			move_cursor_to_end()
			get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_BACKSPACE and key_event.alt_pressed:
		if input_line.text != "":
			var index: int = get_previous_word_index()
			input_line.text = input_line.text.substr(0, index) + input_line.text.substr(input_line.caret_column)
			input_line.caret_column = index
			get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_LEFT and key_event.alt_pressed:
		if input_line.text != "":
			input_line.caret_column = get_previous_word_index()
			get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_RIGHT and key_event.alt_pressed:
		if input_line.text != "":
			input_line.caret_column = get_next_word_index()
			get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_A and key_event.ctrl_pressed:
		input_line.caret_column = 0
		get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_E and key_event.ctrl_pressed:
		move_cursor_to_end()
		get_viewport().set_input_as_handled()
	
	if key_event.keycode == KEY_U and key_event.ctrl_pressed:
		input_line.text = ""
		get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	if not visible: return
	if get_viewport().gui_get_focus_owner() == null:
		input_line.grab_focus.call_deferred()

func _on_input_submit(input: String) -> void:
	input_line.clear()
	var result: String = _dev_console.process_command(input)
	output_label.text = result

func _on_text_changed(new_text: String) -> void:
	var completion_results: CompletionResults = _dev_console.get_completions(new_text)
	var completion: String = completion_results.get_best_completion()
	if completion:
		ghost_text.placeholder_text = completion
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

## Find the start of the previous word (for deleting/navigating).
func get_previous_word_index() -> int:
	var previous_text: String = input_line.text.substr(0, input_line.caret_column)
	var words: PackedStringArray = previous_text.split(" ")
	
	# remove all previous spaces to get to previous word
	while len(words) > 0 and words[len(words) - 1] == "":
		words.remove_at(len(words) - 1)
	
	if words.size() > 0: words.remove_at(len(words) - 1)
	
	var total_length: int = 0
	for word: String in words:
		total_length += len(word) + 1 # since we removed a space, we need to add 1 to the total length.
	
	return total_length

func get_next_word_index() -> int:
	var after_text: String = input_line.text.substr(input_line.caret_column)
	var after_words: PackedStringArray = after_text.split(" ")
	
	var after_words_index: int = 1
	while len(after_words) > after_words_index + 1 and after_words[after_words_index] == "":
		after_words_index += 1
	
	
	var offset: int = 0
	for i: int in range(after_words_index):
		offset += len(after_words[i]) + 1
	
	return input_line.caret_column + offset
