class_name GenericPathosCardPool extends CardPoolModel
## Generic cards with a Pathos cost.

func _generate_all_cards() -> Array[CardModel]:
	return [
		ModelDb.card(Ponder),
		ModelDb.card(Counter),
		ModelDb.card(Rhetoric),
		ModelDb.card(Takedown),
		ModelDb.card(Guard),
		ModelDb.card(MotteAndBailey),
	]
