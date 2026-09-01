class_name MapPointNode extends Control
## A node for a map point.
##
## Has a [method create].

signal pressed(map_point_node: MapPointNode)

const SCENE: PackedScene = preload("res://scenes/screens/map/map_point.tscn")

var map_point: MapPoint

@onready var button: TextureButton = %Button

static func create(point: MapPoint) -> MapPointNode:
	var map_point_node: MapPointNode = SCENE.instantiate()
	map_point_node.map_point = point
	return map_point_node

func _ready() -> void:
	button.pressed.connect(_on_pressed)
	
	RunManager.instance.map_point_visited.connect(_on_map_point_visited)
	
	update_visuals()

func update_visuals() -> void:
	print(RunManager.instance.run_state.curent_map_point)
	if is_current():
		modulate = Color(1,0,0,1)
	elif is_visited():
		modulate = Color(0,1,0,1)
	elif not can_visit():
		modulate = Color(0,0,0,0.25)
	else:
		modulate = Color(0,0,0,1)

func _on_map_point_visited(_map_point: MapPoint):
	update_visuals()

func _on_pressed() -> void:
	pressed.emit(self)

func is_visited() -> bool:
	return RunManager.instance.run_state.visited_map_points.has(map_point)

func is_current() -> bool:
	return RunManager.instance.run_state.curent_map_point == map_point

func can_visit() -> bool:
	return RunManager.instance.can_visit_map_point(map_point)
