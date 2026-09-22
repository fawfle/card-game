class_name FounderEncounter extends EncounterModel

func generate_enemies() -> Array[EnemyModel]:
	return [ModelDb.enemy(Founder)]
