class_name Confuse extends CardModel

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

func get_rarity() -> Constants.Rarity: return Constants.Rarity.COMMON

func get_icon() -> Texture2D: return preload("res://assets/icons/misdirection.png")

func get_description() -> String: return "Appiles %d confused." % confused_amount

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(8.0)

var confused_amount: int = 2

func on_play(card_play: CardPlay) -> void:
	await EffectCommand.new(ConfusedEffect, card_play.target, confused_amount).from_card(self).execute()
