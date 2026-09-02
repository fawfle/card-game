class_name SchoolOfThought extends ActModel

func get_normal_encounters() -> Array[EncounterModel]:
	return [
		ModelDb.encounter(KevinEncounter)
	]

func get_boss_encounters() -> Array[EncounterModel]:
	return []
