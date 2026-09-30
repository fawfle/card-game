class_name Backpedal extends CardModel

func get_description() -> String: return "Gain {ShieldAmount} shield, but lose %d convincing for %.1f seconds." % [-convincing_amount, convincing_debuff_duration]

func get_tool_tips() -> Array[ToolTip]: return [ToolTip.from_effect_type(ConvincingEffect)]

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func get_rarity() -> Constants.Rarity: return Constants.Rarity.COMMON

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(5.0)

func _get_base_dynamic_variables() -> DynamicVariableSet: return DynamicVariableSet.new([
	ShieldAmountVariable.new(ShieldAmountVariable.DEFAULT_NAME, 15)
])

var convincing_amount: int = -20
var convincing_debuff_duration: float = 8.0

func on_play(_card_play: CardPlay) -> void:
	await ShieldCommand.new(owner.creature).from_card(self).with_shield(dynamic_variables.shield_amount.value).execute()
	await EffectCommand.new(ConvincingEffect, owner.creature, convincing_amount).with_duration(convincing_debuff_duration).execute()
