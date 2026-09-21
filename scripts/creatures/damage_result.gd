class_name DamageResult
## A class to help organize information about damage dealt
##
## NOTE: Currently holds pretty limited information about damage

## The total damage dealt
var total_damage: int
## The total damage successfully blocked
var blocked_damage: int
## The total damage dealt as hp
var unblocked_damage: int

var target: Creature

func _init(target_creature: Creature) -> void:
	target = target_creature
