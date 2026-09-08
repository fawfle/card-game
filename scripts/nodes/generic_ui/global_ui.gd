class_name GlobalUi extends Control
## Container to hold global UI during a run.

@onready var overlay_screen: SceneContainer = %OverlayScreen
@onready var map_screen: MapScreen = %MapScreen
@onready var draw_pile_button: DeckButton = %DrawPileButton

func initialize(run_state: RunState) -> void:
	draw_pile_button.initialize(run_state.player)

func set_overlay_screen(node: Control) -> void:
	overlay_screen.set_current_scene(node)

func close_overlay_screen() -> void:
	overlay_screen.set_current_scene(null)

## Close the overlay screen if the node is the current screen
func close_overlay_screen_if_active(node: Control) -> void:
	if overlay_screen.current_scene != node: return
	close_overlay_screen()
