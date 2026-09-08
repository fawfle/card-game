@abstract
class_name ActModel extends AbstractModel
## An act is a stage of the game.
##
## It consists of a pool of encounters and other information that form the map.

## An ORDERED list of every encounter (which are collected into sets of multiple "candidate" encounters)
var normal_encounter_sets: Array[EncounterSet]

var boss_encounter_set: EncounterSet

## Get an ORDERED list of normal encounters as EncounterSets. EncounterSets are collections of encounters which are then picked at random. Don't call outside of initialization, use [member normal_encounter_sets] instead.
@abstract func _get_normal_encounter_sets() -> Array[EncounterSet]

## Get the boss encounter set. For initialization. Use [member boss_encounter_set] for normal use.
@abstract func _get_boss_encounter_set() -> EncounterSet

func _after_model_db_initialized() -> void:
	normal_encounter_sets = _get_normal_encounter_sets()
	boss_encounter_set = _get_boss_encounter_set()

func get_length() -> int:
	var length: int = 0
	length += normal_encounter_sets.size()
	if boss_encounter_set.encounters.size() > 0: length += 1
	return length
