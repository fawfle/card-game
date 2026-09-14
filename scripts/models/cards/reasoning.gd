class_name Reasoning extends CardModel
## No cost, hits on play and on timeout

func get_icon() -> Texture2D: return preload("res://assets/icons/thinking_icon.png")

func get_description() -> String: return "Deals %d damage when played. Deals %d damage when this card times out." % [start_damage, end_damage]

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

var start_damage: int = 1
var end_damage: int = 2

func get_play_duration() -> float: return 5.0

func on_play(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	AttackCommand.new().from_card(self).targeting(card_play.target).with_damage(start_damage).execute()

func on_timeout(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	AttackCommand.new().from_card(self).targeting(card_play.target).with_damage(end_damage).execute()
