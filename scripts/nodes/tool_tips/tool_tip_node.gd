class_name ToolTipNode extends MarginContainer
## Shows a ToolTip

const SCENE: PackedScene = preload("res://scenes/ui/tool_tip.tscn")

var tip: ToolTip

@onready var title: Label = %Title
@onready var description: RichTextLabel = %Description

static func create_and_show(container: Control, hover_tip: ToolTip) -> ToolTipNode:
	var hover_tip_node: ToolTipNode = SCENE.instantiate()
	hover_tip_node.tip = hover_tip
	container.add_child(hover_tip_node)
	hover_tip_node.owner = container
	hover_tip_node.set_alignment(container)
	return hover_tip_node

static func remove(container: Control) -> void:
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
