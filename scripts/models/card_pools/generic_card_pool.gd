class_name GenericCardPool extends CardPoolModel
## Generic cards without a costs.

func _generate_all_cards() -> Array[CardModel]:
	return [
		ModelDb.card(Waffle),
		ModelDb.card(Reasoning),
		ModelDb.card(Setup),
	]
