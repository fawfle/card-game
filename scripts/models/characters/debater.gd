class_name DebaterCharacter extends CharacterModel

func get_starting_max_hp() -> int: return 25

func get_starting_max_pathos() -> int: return 3

func get_starting_max_logos() -> int: return 5

func get_starting_initial_card_count() -> int: return 5

func get_starting_draw_time() -> float: return 2.0

func get_starting_pathos_time() -> float: return 3.0

func get_starting_deck() -> Array[CardModel]:
	return [
		ModelDb.card(Argue),
		ModelDb.card(Argue),
		ModelDb.card(Argue),
		ModelDb.card(Argue),
		ModelDb.card(Defend),
		ModelDb.card(Defend),
		ModelDb.card(Defend),
		ModelDb.card(Defend),
		ModelDb.card(Ponder),
		ModelDb.card(Counter),
	]
