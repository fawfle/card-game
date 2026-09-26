class_name Repeat extends CardModel

func get_icon() -> Texture2D: return preload("res://assets/icons/cycle.png")

func get_description() -> String: return "Applies %d repeat." % repeat_count

func get_extra_tool_tips() -> Array[ToolTip]: return [ToolTip.from_effect_type(RepeatEffect)]

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func get_rarity() -> Constants.Rarity: return Constants.Rarity.COMMON

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(10.0)

func _get_base_pathos_cost() -> int: return 1

var repeat_count: int = 1

func on_play(_card_play: CardPlay) -> void:
	await EffectCommand.new(RepeatEffect, owner.creature, repeat_count).from_card(self).execute()
