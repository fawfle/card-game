class_name Defend extends CardModel
## Basic shield.

const ICON: Texture2D = preload("res://assets/icons/shield_icon.webp")

func get_base_dynamic_variables() -> DynamicVariableSet:
	return DynamicVariableSet.new(
		ShieldAmountVariable.new(ShieldAmountVariable.DEFAULT_NAME, 3)
	)

func get_description() -> String: return "Gain {ShieldAmount} shield."

func get_icon() -> Texture2D: return ICON

func get_play_duration() -> float: return 5.0

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func on_play(card_play: CardPlay) -> void:
	ShieldCommand.new(card_play.card.owner.creature).with_shield(dynamic_variables.shield_amount.base_value).from_card(self).execute()
