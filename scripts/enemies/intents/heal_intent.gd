class_name HealIntent extends AbstractIntent

func get_title() -> String: return "Heal"

func get_description(_owner: Creature, _targets: Array[Creature]) -> String: return "Intends to heal"

func get_icon() -> Texture2D: return preload("res://assets/icons/heal.png")

func get_label(_owner: Creature, _targets: Array[Creature]) -> String: return str(_heal_amount)

var _heal_amount: int

func _init(heal_amount: int) -> void:
	_heal_amount = heal_amount
