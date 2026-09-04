class_name TestAct extends ActModel

func get_normal_encounters() -> Array[EncounterSet]:
	return [EncounterSet.new([ModelDb.encounter(TestEncounter)])]

func get_boss_encounters() -> Array[EncounterModel]:
	return [ModelDb.encounter(TestEncounter)]
