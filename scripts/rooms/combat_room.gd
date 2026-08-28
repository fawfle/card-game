class_name CombatRoom

var combat_state: CombatState = null


## TODO with encounter
static func create():
	pass

## Create a default CombatRoom from a CombatState. Mostly for debugging.
static func create_from_state(state: CombatState) -> CombatRoom:
	var room: CombatRoom = CombatRoom.new()
	room.combat_state = state
	return room

func enter(run_state: RunState):
	CombatManager.instance.start_combat(run_state, self)
