class_name EffectIntent extends AbstractIntent
## Represents that an enemy will apply an effect.

enum TARGET_TYPE {
	NONE,
	BUFF,
	DEBUFF
}

func get_title() -> String: return "Effect"

func get_icon() -> Texture2D: return preload("res://assets/icons/brain_icon.webp")

func get_extra_icon() -> Texture2D:
	match(_target_type):
		TARGET_TYPE.BUFF: return preload("res://assets/icons/arrow_up.webp")
		TARGET_TYPE.DEBUFF: return preload("res://assets/icons/arrow_down.webp")
	return null

var _effect: EffectModel
var _amount: int
var _target_type: TARGET_TYPE

func get_label(_owner: Creature, _targets: Array[Creature]) -> String: return str(_amount)

func get_description(_owner: Creature, _targets: Array[Creature]) -> String: return "Intends to apply %d %s" % [_amount, _effect.get_title()]

func _init(effect_type: Script, amount: int, target_type: TARGET_TYPE) -> void:
	_effect = ModelDb.effect(effect_type)
	_amount = amount
	_target_type = target_type
