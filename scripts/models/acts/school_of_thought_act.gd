class_name SchoolOfThought extends ActModel

func _get_normal_encounter_sets() -> Array[EncounterSet]:
	return [
		EncounterSet.new([
		ModelDb.encounter(KevinEncounter),
		ModelDb.encounter(TurtleEncounter),
		ModelDb.encounter(StudentEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(TeacherEncounter),
		ModelDb.encounter(SkepticEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(PartierEncounter),
		ModelDb.encounter(ClubPresidentEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(AthleteEncounter),
		ModelDb.encounter(NerdEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(PhilosopherEncounter),
		ModelDb.encounter(ProfessorEncounter),
		]),
		EncounterSet.new([
		ModelDb.encounter(BoredMemberEncounter),
		ModelDb.encounter(AnonymousDonorEncounter),
		]),
	]

func _get_boss_encounter_set() -> EncounterSet:
	return EncounterSet.new([ModelDb.encounter(FounderEncounter)])
