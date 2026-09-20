class_name ClubPresidentEncounter extends EncounterModel

func generate_enemies() -> Array[EnemyModel]:
	return [ModelDb.enemy(ClubPresident)]
