class_name Argue extends CardModel
## A basic attack.

func get_icon() -> Texture2D: return preload("res://assets/icons/weapon_icon.webp")

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

var damage: int = 2

func get_description() -> String: return "Deal %d damage." % damage

func on_play(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	AttackCommand.new().targeting(card_play.target).from_card(self).with_damage(damage).execute()
