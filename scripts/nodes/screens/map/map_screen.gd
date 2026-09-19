class_name MapScreen extends Control

static var instance: MapScreen:
	get(): return RunNode.instance.global_ui.map_screen

var _map: Map

var is_open: bool = false
var _can_travel: bool = false

@onready var map_point_container: HBoxContainer = %MapPointContainer

func _ready() -> void:
	RunManager.instance.map_point_visited.connect(_on_map_point_visited)

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey: return
	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed: return
	
	if key_event.keycode == KEY_M:
		toggle()
		get_viewport().set_input_as_handled()

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

func toggle() -> void:
	if is_open: close()
	else: open()

## Enable if the player can travel.
func set_travel_enabled(enabled: bool) -> void:
	_can_travel = enabled
	update_visuals()

func _on_map_point_pressed(map_point_node: MapPointNode) -> void:
	if not _can_travel: return
	if RunManager.instance.can_visit_map_point(map_point_node.map_point):
		RunManager.instance.enter_map_point(map_point_node.map_point);

func _on_map_point_visited(_map_point: MapPoint):
	update_visuals()

func update_visuals() -> void:
	for child: MapPointNode in map_point_container.get_children():
		child.update_visuals()
