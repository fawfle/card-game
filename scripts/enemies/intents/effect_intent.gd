class_name EffectIntent extends AbstractIntent
## Represents that an enemy will apply an effect.

func get_title() -> String: return "Effect"

func get_icon() -> Texture2D: return preload("res://assets/icons/brain_icon.webp")

var _effect: EffectModel
var _amount: int

func get_label(_owner: Creature, _targets: Array[Creature]) -> String: return str(_amount)

func get_description(_owner: Creature, _targets: Array[Creature]) -> String: return "Intends to apply %d %s" % [_amount, _effect.get_title()]

func _init(effect_type: Script, amount: int) -> void:
	_effect = ModelDb.effect(effect_type)
	_amount = amount
