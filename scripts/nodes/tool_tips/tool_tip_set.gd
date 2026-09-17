class_name ToolTipSet extends PanelContainer
## Display a set of tool tips
##
## NOTE: extends PanelContainer so it resizes to fit its content, useful for setting alignment

const SCENE = preload("res://scenes/ui/tool_tip_set.tscn")

var _tool_tips: Array[ToolTip]

@onready var tool_tip_container: VBoxContainer = %ToolTipContainer

## TODO: Add alignment
static func create_and_show(container: Control, tool_tips: Array[ToolTip], alignment: Constants.Alignment = Constants.Alignment.NONE) -> ToolTipSet:
	var tool_tip_set: ToolTipSet = SCENE.instantiate()
	tool_tip_set._tool_tips = tool_tips
	container.add_child(tool_tip_set)
	tool_tip_set.owner = container
	AlignmentHelper.set_alignment(tool_tip_set, container, alignment)
	return tool_tip_set

func _ready() -> void:
	for tip: ToolTip in _tool_tips:
		tool_tip_container.add_child(ToolTipNode.create(tip))

static func remove_from(container: Control) -> void:
	for child in container.get_children():
		if child is ToolTipSet:
			child.queue_free()
