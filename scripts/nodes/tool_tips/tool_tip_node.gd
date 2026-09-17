class_name ToolTipNode extends MarginContainer
## Shows a ToolTip

const SCENE: PackedScene = preload("res://scenes/ui/tool_tip.tscn")

var tip: ToolTip

@onready var title: Label = %Title
@onready var description: RichTextLabel = %Description

static func create_and_show(container: Control, tool_tip: ToolTip) -> ToolTipNode:
	var tool_tip_node: ToolTipNode = SCENE.instantiate()
	tool_tip_node.tip = tool_tip
	container.add_child(tool_tip_node)
	tool_tip_node.owner = container
	tool_tip_node.set_alignment(container)
	return tool_tip_node

static func create(tool_tip: ToolTip) -> ToolTipNode:
	var tool_tip_node: ToolTipNode = SCENE.instantiate()
	tool_tip_node.tip = tool_tip
	return tool_tip_node

static func remove_from(container: Control) -> void:
	for child in container.get_children():
		if child is ToolTipNode:
			child.queue_free()

func _ready() -> void:
	title.text = tip.title
	description.text = tip.description

func set_alignment(container: Control) -> void:
	global_position = container.global_position
	global_position.x -= size.x
	size.y = 0
