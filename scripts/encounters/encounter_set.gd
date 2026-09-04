class_name EncounterSet
## A collection of encounters.

var encounters: Array[EncounterModel]

func _init(encounters_array: Array[EncounterModel]) -> void:
	encounters = encounters_array
