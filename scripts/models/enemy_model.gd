@abstract
class_name EnemyModel extends AbstractModel

signal move_changed(move: MoveState)

var base_instance: EnemyModel:
	get():
		if is_base: return self
		return base_instance
	set(value):
		assert_mutable()
		base_instance = value

var move_state_machine: MoveStateMachine:
	set(value):
		assert_mutable()
		if move_state_machine != null: push_error("move_state_machine is already set.")
		move_state_machine = value

var next_move: MoveState:
	get(): return move_state_machine.current_state if move_state_machine != null else null

var is_performing_move: bool = false

var creature: Creature = null:
	set(value):
		assert_mutable()
		if creature != null: push_error("creature is already set.")
		creature = value

var combat_state: CombatState:
	get(): return creature.combat_state if creature else null

@abstract
func get_max_hp() -> int

@abstract func generate_move_state_machine() -> MoveStateMachine

func get_visuals() -> PackedScene:
	var path: String = "res://scenes/creature_visuals/%s.tscn" % id_snakecase
	if ResourceLoader.exists(path): return load(path)
	return null

func after_cloned() -> void:
	super.after_cloned()
	if base_instance == null: base_instance = ModelDb.enemy(get_script())

func set_up_for_combat() -> void:
	move_state_machine = generate_move_state_machine()
	move_state_machine.state_changed.connect(_on_state_changed)

func should_perform_move() -> bool:
	return move_state_machine.spent_enough_time_in_state()

## Perform a move, do its effects, and load the next state. For default behavior, it's managed by [CombatState].
func perform_move() -> void:
	if is_performing_move == null: push_error("Currently already performing a move.")
	is_performing_move = true
	await next_move.perform()
	move_state_machine.get_next_state()
	is_performing_move = false
	
func _on_state_changed(state: MoveState):
	move_changed.emit(state)
