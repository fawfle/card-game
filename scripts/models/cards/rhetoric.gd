class_name Rhetoric extends CardModel
## Basic convincing card, temporary.

func get_icon() -> Texture2D: return preload("res://assets/icons/rhetoric_icon.png")

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func get_pathos_cost() -> int: return 3

func get_play_duration() -> float: return 5.0

var convincing_amount: int = 2

func get_description() -> String: return "Gives %s convincing while the card is in play." % [convincing_amount]

func on_play(card_play: CardPlay) -> void:
	EffectCommand.new(ConvincingEffect, card_play.target, convincing_amount).from_card(self).execute()
