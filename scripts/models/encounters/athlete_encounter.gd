class_name AthleteEncounter extends EncounterModel

func generate_enemies() -> Array[EnemyModel]:
	return [ModelDb.enemy(Athlete)]
