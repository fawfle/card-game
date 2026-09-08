class_name SchoolOfThought extends ActModel

func _get_normal_encounter_sets() -> Array[EncounterSet]:
	return [
		EncounterSet.new([
		ModelDb.encounter(KevinEncounter),
		ModelDb.encounter(TurtleEncounter),
		ModelDb.encounter(StudentEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(KevinEncounter),
		ModelDb.encounter(TurtleEncounter),
		ModelDb.encounter(StudentEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(KevinEncounter),
		ModelDb.encounter(TurtleEncounter),
		ModelDb.encounter(StudentEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(KevinEncounter),
		ModelDb.encounter(TurtleEncounter),
		ModelDb.encounter(StudentEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(KevinEncounter),
		ModelDb.encounter(TurtleEncounter),
		ModelDb.encounter(StudentEncounter),
		]),
	]

func _get_boss_encounter_set() -> EncounterSet:
	return EncounterSet.new([ModelDb.encounter(KevinEncounter)])
