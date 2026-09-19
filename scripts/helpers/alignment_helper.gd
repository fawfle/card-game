class_name AlignmentHelper

## Set the position of a child control relative to a node based on a preset alignment.
static func set_alignment(child: Control, node: Control, alignment: Constants.Alignment) -> void:
	if alignment == Constants.Alignment.NONE: return
	
	match(alignment):
		Constants.Alignment.LEFT:
			child.global_position = node.global_position
			child.global_position.x -= child.size.x
		Constants.Alignment.RIGHT:
			child.global_position = node.global_position
			child.global_position.x += node.size.x
		Constants.Alignment.CENTER_TOP:
			child.global_position = node.global_position
			child.global_position.x += node.size.x / 2 - child.size.x / 2
			child.global_position.y -= child.size.y
