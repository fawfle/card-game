@abstract
class_name AbstractIntent
## A preview for an action an enemy can perform. For visuals.

@abstract func get_title() -> String

@abstract func get_icon() -> Texture2D

## Get an extra icon for stuff like if an effect is a buff or debuff
func get_extra_icon() -> Texture2D: return null

func get_label(_owner: Creature, _targets: Array[Creature]) -> String: return ""

func get_tool_tip(owner: Creature, targets: Array[Creature]) -> ToolTip:
	return ToolTip.new(get_title(), get_description(owner, targets))

func get_description(_owner: Creature, _targets: Array[Creature]) -> String:
	return "broken description"
