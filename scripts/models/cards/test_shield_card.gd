class_name TestShieldCard extends CardModel

const ICON: Texture2D = preload("res://assets/icons/shield_icon.webp")

func get_description() -> String: return "Gain %d shield." % 5

func get_icon() -> Texture2D: return ICON

func get_play_duration() -> float: return 5.0

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func on_play(card_play: CardPlay) -> void:
	ShieldCommand.new(card_play.card.owner.creature).with_shield(5).from_card(self).execute()
