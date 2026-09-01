@abstract
class_name ActModel extends AbstractModel
## An act is a stage of the game.
##
## It consists of a pool of encounters and other information that form the map.

@abstract func get_normal_encounters() -> Array[EncounterModel]

@abstract func get_boss_encounters() -> Array[EncounterModel]
