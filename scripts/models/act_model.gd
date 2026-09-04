@abstract
class_name ActModel extends AbstractModel
## An act is a stage of the game.
##
## It consists of a pool of encounters and other information that form the map.

## Get an ORDERED list of normal encounters as EncounterSets. EncounterSets are collections of encounters which are then picked at random.
@abstract func get_normal_encounters() -> Array[EncounterSet]

@abstract func get_boss_encounters() -> Array[EncounterModel]

func get_length() -> int:
	var length: int = 0
	length += get_normal_encounters().size()
	if get_boss_encounters().size() > 0: length += 1
	return length
