class_name ShieldIntent extends AbstractIntent

const ICON: Texture2D = preload("res://assets/icons/shield_icon.webp")

func get_title() -> String: return "Shield"

func get_description(_owner: Creature, _targets: Array[Creature]) -> String: return "Intends to appy a shield."

func get_icon() -> Texture2D: return ICON

var _shield: int = 0

func get_label(_owner: Creature, _targets: Array[Creature]) -> String: return str(_shield)

func _init(shield: int) -> void:
	_shield = shield
