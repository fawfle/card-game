class_name Takedown extends CardModel
# Simple damage card

func get_icon() -> Texture2D: return preload("res://assets/icons/dagger.webp")

func get_description() -> String: return "Deal {Damage} damage."

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

func _get_base_pathos_cost() -> int: return 1

func _get_base_dynamic_variables() -> DynamicVariableSet:
	return DynamicVariableSet.new([
		DamageVariable.new(DamageVariable.DEFAULT_NAME, 4)
	])

func on_play(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	AttackCommand.new().from_card(self).targeting(card_play.target).with_damage(dynamic_variables.damage.value).execute()
