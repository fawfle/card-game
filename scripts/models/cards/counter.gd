class_name Counter extends CardModel
## Basic counter.

func get_icon() -> Texture2D: return preload("res://assets/icons/shield_reflect.webp")

const COUNTER_DAMAGE: String = &"CounterDamage"

func get_base_dynamic_variables() -> DynamicVariableSet:
	return DynamicVariableSet.new(
		ShieldAmountVariable.new(ShieldAmountVariable.DEFAULT_NAME, 2),
		DamageVariable.new(COUNTER_DAMAGE, 3),
	)

func get_base_keywords() -> Array[Constants.CardKeyword]: return [Constants.CardKeyword.FRAGILE]

func get_play_duration() -> float: return 1.00

func get_pathos_cost() -> int: return 1

 # description accounts for keywords (i.e. fragile)
func get_description() -> String: return "Gain {ShieldAmount} shield. If the card is cancelled, deal {CounterDamage} damage."

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func on_play(card_play: CardPlay) -> void:
	ShieldCommand.new(card_play.card.owner.creature).with_shield(dynamic_variables.shield_amount.base_value).from_card(self).with_priority(Constants.ShieldPriority.COUNTER).execute()

func on_cancelled(creature_source: Creature) -> void:
	if creature_source.enemy:
		AttackCommand.new().from_card(self).targeting(creature_source).with_damage(dynamic_variables.list[COUNTER_DAMAGE].base_value).execute()
		VfxCommand.play_on_creature_front(owner.creature, preload("res://scenes/vfx/objection.tscn"))
