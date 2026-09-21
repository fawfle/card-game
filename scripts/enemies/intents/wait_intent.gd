class_name WaitIntent extends AbstractIntent

const ICON: Texture2D = preload("res://assets/icons/night_sleep.png")

func get_title() -> String: return "Wait"

func get_description(_owner: Creature, _targets: Array[Creature]) -> String: return "Intends to do nothing."

func get_icon() -> Texture2D: return ICON

func get_label(_owner: Creature, _targets: Array[Creature]) -> String: return ""

func _init() -> void:
	pass
