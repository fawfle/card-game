class_name Waffle extends CardModel

func get_icon() -> Texture2D: return preload("res://assets/icons/roundabout.webp")

func get_description() -> String: return "When this card times out, deal %d damage." % damage_amount

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(5.0)

var damage_amount: int = 3

func on_timeout(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	await AttackCommand.new(damage_amount).from_card(self).targeting(card_play.target).execute()
