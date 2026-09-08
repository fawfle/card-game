class_name RunNode extends Control

const RUN_SCENE: PackedScene = preload("res://scenes/run.tscn")

static var instance: RunNode:
	get():
		if GameNode.instance != null: return GameNode.instance.get_run_node()
		return null

var _state: RunState = null

func get_combat_room() -> Control: return _room_container.current_scene if _room_container.current_scene is CombatRoomNode else null

@onready var _room_container: SceneContainer = %RoomContainer
@onready var global_ui: GlobalUi = %GlobalUi

## Creates a run from a RunState. Use to instantiate the actual scene instead of the script.
static func create(run_state: RunState) -> RunNode:
	var run_node: RunNode = RUN_SCENE.instantiate()
	run_node._state = run_state
	return run_node

func _ready() -> void:
	global_ui.initialize(_state)

## Clear the current room. Probably unecesary.
func clear_current_room() -> void:
	_room_container.set_current_scene(null)

func set_current_room(room: Control) -> void:
	_room_container.set_current_scene(room)
