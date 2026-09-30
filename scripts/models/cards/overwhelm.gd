class_name Overwhelm extends CardModel

const DAMAGE_PER_CARD: String = &"DamagePerCard"

func get_description() -> String: return "Deals {DamagePerCard} damage for each card in play."

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

func get_rarity() -> Constants.Rarity: return Constants.Rarity.COMMON

func _get_base_pathos_cost() -> int: return 1

func _get_base_dynamic_variables() -> DynamicVariableSet: return DynamicVariableSet.new([
	DamageVariable.new(DAMAGE_PER_CARD, 2)
])

func on_play(_card_play: CardPlay) -> void:
	var other_cards_in_play: int = owner.player_combat_state.play_pile.cards.size() - 1
	await AttackCommand.new(other_cards_in_play * dynamic_variables.list[DAMAGE_PER_CARD].value).from_card(self).targeting(get_target()).execute()
