class_name TestCharacter extends CharacterModel

func get_starting_max_hp() -> int: return 99

func get_starting_max_pathos() -> int: return 3

func get_starting_max_logos() -> int: return 3

func get_starting_initial_card_count() -> int: return 3

func get_starting_draw_time() -> float: return 4.0

func get_starting_pathos_time() -> float: return 4.0

func get_starting_deck() -> Array[CardModel]: return [
	ModelDb.card(TestDamageCard),
	ModelDb.card(TestDamageCard),
	ModelDb.card(TestDamageCard),
	ModelDb.card(TestDamageCard),
	ModelDb.card(TestDamageCard),
	ModelDb.card(TestShieldCard),
	ModelDb.card(TestShieldCard),
	ModelDb.card(TestShieldCard),
	ModelDb.card(TestShieldCard),
	ModelDb.card(TestShieldCard),
]
