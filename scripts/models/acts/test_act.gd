class_name TestAct extends ActModel

func _get_normal_encounter_sets() -> Array[EncounterSet]:
	return [EncounterSet.new([ModelDb.encounter(TestEncounter)])]

func _get_boss_encounter_set() -> EncounterSet:
	return EncounterSet.new([ModelDb.encounter(TestEncounter)])
