class_name MapScreen extends Control

static var instance: MapScreen:
	get(): return RunNode.instance.global_ui.map_screen

var _map: Map

var is_open: bool = false
var _can_travel: bool = false

@onready var map_point_container: HBoxContainer = %MapPointContainer

func set_map(map: Map) -> void:
	_map = map
	
	for child in map_point_container.get_children():
		child.queue_free()
	
	for map_point: MapPoint in map.map_points:
		var map_point_node: MapPointNode = MapPointNode.create(map_point)
		map_point_node.pressed.connect(_on_map_point_pressed)
		map_point_container.add_child(map_point_node)

func open() -> void:
	if is_open: return
	is_open = true
	visible = true

func close() -> void:
	if not is_open: return
	is_open = false
	visible = false

## Enable if the player can travel.
func set_travel_enabled(enabled: bool) -> void:
	_can_travel = enabled

func _on_map_point_pressed(map_point_node: MapPointNode) -> void:
	if not _can_travel: return
	if RunManager.instance.can_visit_map_point(map_point_node.map_point):
		RunManager.instance.enter_map_point(map_point_node.map_point);
