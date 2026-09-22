class_name Argue extends CardModel
## A basic attack.

func get_icon() -> Texture2D: return preload("res://assets/icons/weapon_icon.webp")

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

func _get_base_dynamic_variables() -> DynamicVariableSet:
	return DynamicVariableSet.new([
		DamageVariable.new(DamageVariable.DEFAULT_NAME, 2)
	])

func get_description() -> String: return "Deal {Damage} damage."

func on_play(card_play: CardPlay) -> void:
	card_play.assert_has_target()
	await AttackCommand.new(dynamic_variables.damage.value).targeting(card_play.target).from_card(self).execute()
