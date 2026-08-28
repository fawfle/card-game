class_name TestEncounter extends EncounterModel

func generate_enemies() -> Array[EnemyModel]:
	return [ModelDb.enemy(TestEnemy)]
