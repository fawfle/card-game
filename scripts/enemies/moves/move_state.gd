class_name MoveState
## A state representing an enemy's move.

var _name: String = ""

## How long the enemy is in the MoveState for before moving on. Access with [method get_move_time].
var _move_time: float = 0
var next_state: MoveState = null

var intents: Array[AbstractIntent] = []

## A method to be called when the move is performed. Should take no arguments.
var _on_perform: Callable

func _init(name: String, on_perform: Callable, move_time: float, intent_list: Array[AbstractIntent]) -> void:
	_name = name
	_on_perform = on_perform
	_move_time = move_time
	intents = intent_list

## Takes no parameters. The execution method [member _on_perform] is expected to already have a reference to the [CombatState] the enemy wants to affect.
func perform() -> void:
	await _on_perform.call()

func get_move_time() -> float:
	return Hook.modify_move_time(_move_time)
