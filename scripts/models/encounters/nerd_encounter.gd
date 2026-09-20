class_name NerdEncounter extends EncounterModel

func generate_enemies() -> Array[EnemyModel]:
	return [ModelDb.enemy(Nerd)]
