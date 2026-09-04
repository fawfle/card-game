class_name CombatRoom

var combat_state: CombatState = null


static func create_from_encounter(run_state: RunState, encounter: EncounterModel):
	encounter.assert_mutable()
	var room: CombatRoom = CombatRoom.new()
	room.combat_state = CombatState.create_from_encounter(run_state, encounter)
	return room

## Create a default CombatRoom from a CombatState. Mostly for debugging.
static func create_from_state(state: CombatState) -> CombatRoom:
	var room: CombatRoom = CombatRoom.new()
	room.combat_state = state
	return room

func enter(run_state: RunState):
	run_state.current_room = self
	CombatManager.instance.start_combat(run_state, self)

func exit() -> void:
	CombatManager.instance.reset()
	RunNode.instance.clear_current_room()
