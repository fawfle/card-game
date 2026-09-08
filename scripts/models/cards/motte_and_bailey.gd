class_name MotteAndBailey extends CardModel

func get_title() -> String: return "Motte-and-bailey"

func get_icon() -> Texture2D: return preload("res://assets/icons/castle.webp")

func get_description() -> String: return "Gives %d Support while this card is in play." % support_amount

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func get_play_duration() -> float: return 5.0

func get_logos_cost() -> int: return 1 

var support_amount: int = 1

func on_play(card_play: CardPlay) -> void:
	EffectCommand.new(SupportEffect, owner.creature, support_amount).from_card(self).execute()
