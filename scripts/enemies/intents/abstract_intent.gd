@abstract
class_name AbstractIntent
## A preview for an action an enemy can perform. For visuals.

@abstract func get_title() -> String

@abstract func get_icon() -> Texture2D

func get_label(owner: Creature, targets: Array[Creature]) -> String: return ""

func get_hover_tip(owner: Creature, targets: Array[Creature]) -> ToolTip:
	return ToolTip.new(get_title(), get_description(owner, targets))

func get_description(owner: Creature, targets: Array[Creature]) -> String:
	return "broken description"
