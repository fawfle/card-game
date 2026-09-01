@abstract
class_name EncounterModel extends AbstractModel
## A class representing a combat encounter. Mainly meant to store data.
##
## For now, only holds information about the enemies. TODO: Have information about the entire encounter, like backgrounds and effects.

## Generate the enemies for a given encounter.
@abstract
func generate_enemies() -> Array[EnemyModel]
