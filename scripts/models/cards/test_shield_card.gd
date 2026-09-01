class_name TestShieldCard extends CardModel

const ICON: Texture2D = preload("res://assets/icons/shield_icon.webp")

var shield_amount: int = 15

func get_description() -> String: return "Gain %d shield." % shield_amount

func get_icon() -> Texture2D: return ICON

func get_play_duration() -> float: return 5.0

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func on_play(card_play: CardPlay) -> void:
	ShieldCommand.new(card_play.card.owner.creature).with_shield(shield_amount).from_card(self).execute()
