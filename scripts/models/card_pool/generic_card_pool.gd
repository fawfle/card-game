class_name GenericCardPool extends CardPoolModel
## Generic cards, appear as card rewards for every character.

func _generate_all_cards() -> Array[CardModel]:
	return [
		ModelDb.card(Ponder),
		ModelDb.card(Counter),
		ModelDb.card(Rhetoric),
		ModelDb.card(Takedown),
		ModelDb.card(Waffle),
	]
