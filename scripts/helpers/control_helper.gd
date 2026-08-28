class_name HelperControl
## Not called ControlHelper b/c autocomplete is annoying.

## Helper to manually check "hover". Specifically, when nodes spawn on_mouse_entered doesn't fire until the player moves their mouse.
static func check_hover(control: Control, callable: Callable):
	await control.get_tree().process_frame
	if control.get_global_rect().has_point(control.get_global_mouse_position()):
		callable.call()
