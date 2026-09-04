class_name SchoolOfThought extends ActModel

func get_normal_encounters() -> Array[EncounterSet]:
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
	]

func get_boss_encounters() -> Array[EncounterModel]:
	return []
