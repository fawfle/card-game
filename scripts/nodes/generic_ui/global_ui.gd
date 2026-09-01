class_name GlobalUi extends Control
## Container to hold global UI during a run.

@onready var overlay_screen: SceneContainer = %OverlayScreen
@onready var map_screen: MapScreen = %MapScreen

func set_overlay_screen(node: Control) -> void:
	overlay_screen.set_current_scene(node)

func close_overlay_screen() -> void:
	overlay_screen.set_current_scene(null)
