class_name ToolTipSet extends Control
## Display a set of tool tips

const SCENE = preload("res://scenes/ui/tool_tip_set.tscn")

var _tool_tips: Array[ToolTip]

@onready var tool_tip_container: VBoxContainer = %ToolTipContainer

## TODO: Add alignment
static func create_and_show(container: Control, tool_tips: Array[ToolTip]) -> ToolTipSet:
	var tool_tip_set: ToolTipSet = SCENE.instantiate()
	tool_tip_set._tool_tips = tool_tips
	container.add_child(tool_tip_set)
	tool_tip_set.owner = container
	tool_tip_set.set_alignment(container)
	return tool_tip_set

func _ready() -> void:
	for tip: ToolTip in _tool_tips:
		tool_tip_container.add_child(ToolTipNode.create(tip))

func set_alignment(container: Control) -> void:
	global_position = container.global_position
	global_position.x -= size.x
	size.y = 0

static func remove_from(container: Control) -> void:
	for child in container.get_children():
		if child is ToolTipSet:
			child.queue_free()
