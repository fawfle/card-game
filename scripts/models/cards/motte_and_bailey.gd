class_name MotteAndBailey extends CardModel

func get_title() -> String: return "Motte-and-bailey"

func get_icon() -> Texture2D: return preload("res://assets/icons/castle.webp")

func get_description() -> String: return "Gives %d Support while this card is in play." % support_amount

func get_extra_tool_tips() -> Array[ToolTip]: return [ToolTip.from_effect_type(SupportEffect)]

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(5.0)

func _get_base_pathos_cost() -> int: return 1 

var support_amount: int = 1

func on_play(card_play: CardPlay) -> void:
	EffectCommand.new(SupportEffect, owner.creature, support_amount).from_card(self).execute()
