class_name Setup extends CardModel
## Makes next attack deal more damage (applies setup)

func get_icon() -> Texture2D: return preload("res://assets/icons/electric.png")

func get_description() -> String: return "Gain %d setup while in play." % setup_amount

func get_extra_tool_tips() -> Array[ToolTip]: return [ToolTip.from_effect_type(SetupEffect)]

func get_target_type() -> Constants.TargetType: return Constants.TargetType.NONE

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(10.0)

var setup_amount: int = 2

func on_play(_card_play: CardPlay) -> void:
	EffectCommand.new(SetupEffect, owner.creature, setup_amount).from_card(self).execute()
