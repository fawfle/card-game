class_name MoveStateMachine
## Manages enemy moves.
##
## States should be connected directly to handle transitions.

signal state_changed(state: MoveState)

var _states: Array[MoveState] = []

var current_state: MoveState = null

## The state the machine started on. If the machine encounters a state without a [member MoveState.next_state], the machine will enter this state.
var _starting_state: MoveState = null

var time_spent_in_state: float = 0

func _init(states: Array[MoveState], starting_state) -> void:
	_states = states
	_starting_state = starting_state
	set_current_state(starting_state)

## Get the next state. Upon reaching a null next state, the machine resets to [member _starting_state].
func get_next_state() -> void:
	if current_state == null: push_error("Cannot get next state if current_state is null.")
	var next_state: MoveState = current_state.next_state
	if next_state == null: next_state = _starting_state
	
	set_current_state(next_state)

func set_current_state(state: MoveState) -> void:
	if state == null: push_warning("State was set to null.")
	current_state = state
	time_spent_in_state = 0
	state_changed.emit(state)

func add_state_time_delta_internal(delta: float) -> void:
	if current_state == null: return
	time_spent_in_state = min(time_spent_in_state + Hook.modify_move_time_delta(delta), current_state.get_move_time())

func spent_enough_time_in_state() -> bool:
	return time_spent_in_state >= current_state.get_move_time()
