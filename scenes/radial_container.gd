extends Control

@export var ellipse_size: Vector2 = Vector2(150, 190)
@export var start_angle_degrees: float = 0.0
@export var angle_step_degrees: float = -60.0
@export var max_angle_degrees: float = 180.0

func _process(delta: float) -> void:
	var children := get_children()
	children = children.filter(func(a): return a is Control)
	
	var children_per_ring: int = 1 + abs(floor(max_angle_degrees / angle_step_degrees))
	
	for i: int in len(children):
		var child: Control = children[i]
		var ring_index: int = i / children_per_ring
		var angle_degrees = start_angle_degrees + angle_step_degrees * (i % children_per_ring)
		child.global_position = global_position + Vector2.from_angle(deg_to_rad(angle_degrees)) * ellipse_size * (1 + ring_index)
