class_name ClickableControl extends Control
## A button class that handles more click events than the default control.

## Left clicked
signal pressed()
## Right clicked
signal right_pressed()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var button_event: InputEventMouseButton = event as InputEventMouseButton
		if button_event.pressed and button_event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			pressed.emit()
			accept_event()
		if button_event.pressed and button_event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			right_pressed.emit()
			accept_event()
