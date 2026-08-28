class_name CombatState
## Represents everything in a combat.
##
## Some utilization quirks, like needing to add the player before starting combat, are so CombatStates can be created independently as data while also handling
## active combats. [br][br]
## Because STS2, some details are derived from higher-level objects like Players being derived from their associated creature in combat. [br][br]
## Some of it is probably overkill since this game is singleplayer and currently doesn't have more than 1 ally, but hopefully this keeps it flexible. [br][br]
## NOTE: STS2 also uses combatIds for performance (to compare creatures) but I don't think it'll matter at all for gdscript.

var run_state: RunState = null

## The allies in the CombatState. For now, it is assumed that they all have associated players.
var allies: Array[Creature] = []
## The enemies in the CombatState. For now, it is assumed that they are all enemies.
var enemies: Array[Creature] = []

static var test: CombatState = CombatState.new(null)

## May have overhead. Consider checking [member allies] and [member enemies] separately.
func get_all_creatures() -> Array[Creature]:
	var creatures: Array[Creature] = []
	creatures.assign(allies)
	creatures.append_array(enemies)
	return creatures

func get_players() -> Array[Player]:
	return allies.map(func(ally: Creature): return ally.player).filter(func(player): return player != null)

func get_enemy_models() -> Array[EnemyModel]:
	return get_all_creatures().map(func(creature: Creature): return creature.enemy).filter(func(enemy): return enemy != null)

func _init(state: RunState) -> void:
	run_state = state

func add_player(player: Player) -> void:
	add_creature(player.creature)

## Add a creature to the combat. For possibly good reasons, the side of the creature is stored/set within [member Creature.side] rather than here.
func add_creature(creature: Creature) -> void:
	get_side_array(creature.side).push_back(creature)
	creature.combat_state = self

func creature_in_combat(creature: Creature) -> bool:
	return allies.has(creature) or enemies.has(creature)

## TODO
func get_hook_listeners() -> Array[AbstractModel]:
	var listeners: Array[AbstractModel] = []
	
	#for creature: Creature in allies:
		#listeners.append(creature)
	
	return listeners

## Get the array storing creatures in the combat side. [member allies] corresponds to [enum CombatSide.PLAYER] and [member enemies] correponds to [enum CombatSide.ENEMY].
func get_side_array(side: Constants.CombatSide) -> Array[Creature]:
	if side == Constants.CombatSide.NONE: push_error("CombatSide.NONE has no array")
	return allies if side == Constants.CombatSide.ALLY else enemies
