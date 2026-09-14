class_name GlobalUi extends Control
## Container to hold global UI during a run.

## The lowest level global screen. Use for functional game related menus (like card rewards) that aren't their own room. Below the map_screen.
@onready var _overlay_screen: SceneContainer = %OverlayScreen
@onready var map_screen: MapScreen = %MapScreen
## The highest level global screen. Use for displaying information to the player (like looking at the deck) so they're always available to the player. Above the map_screen.
@onready var _top_screen: SceneContainer = %TopScreen
@onready var deck_button: DeckButton = %DeckButton

func initialize(run_state: RunState) -> void:
	deck_button.initialize(run_state.player)

func set_overlay_screen(node: Control) -> void:
	_overlay_screen.set_current_scene(node)

func close_overlay_screen() -> void:
	_overlay_screen.set_current_scene(null)

## Close the overlay screen if the node is the current screen
func close_overlay_screen_if_active(node: Control) -> void:
	if _overlay_screen.current_scene != node: return
	close_overlay_screen()

## Set the highest level screen (above map).
func set_top_screen(node: Control) -> void:
	_top_screen.set_current_scene(node)

func close_top_screen() -> void:
	_top_screen.set_current_scene(null)

func close_top_screen_if_active(node: Control) -> void:
	if _top_screen.current_scene != node: return
	close_top_screen()
