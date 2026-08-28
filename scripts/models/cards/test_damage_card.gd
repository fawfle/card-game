class_name TestDamageCard extends CardModel

const ICON: Texture2D = preload("res://assets/icons/weapon_icon.webp")

func get_description() -> String: return "Deal %d damage." % damage

func get_icon() -> Texture2D: return ICON

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

var damage: int = 5

func on_play(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	AttackCommand.new().with_damage(damage).targeting(card_play.target).from_card(self).execute()
