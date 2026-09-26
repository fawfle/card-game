class_name Reasoning extends CardModel
## No cost, hits on play and on timeout

func get_icon() -> Texture2D: return preload("res://assets/icons/thinking_icon.png")

func get_description() -> String: return "Deals {StartDamage} damage when played. Deals {EndDamage} damage when this card times out."

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

func get_rarity() -> Constants.Rarity: return Constants.Rarity.COMMON

const START_DAMAGE: String = &"StartDamage"
const END_DAMAGE: String = &"EndDamage"

func _get_base_dynamic_variables() -> DynamicVariableSet:
	return DynamicVariableSet.new([
		DamageVariable.new(START_DAMAGE, 1),
		DamageVariable.new(END_DAMAGE, 1)
	])

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(5.0)

func on_play(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	await AttackCommand.new(dynamic_variables.list[START_DAMAGE].value).from_card(self).targeting(card_play.target).execute()

func on_timeout(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	await AttackCommand.new(dynamic_variables.list[END_DAMAGE].value).from_card(self).targeting(card_play.target).execute()
