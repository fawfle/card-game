class_name Athlete extends EnemyModel

func get_max_hp() -> int: return 30

var quick_throw_damage: int = 1
var dunk_damage: int = 3

func generate_move_state_machine() -> MoveStateMachine:
	# TODO: possibly add a repeater state thing
	var attack_low_state: MoveState = MoveState.new("quick_throw 1", quick_throw_move, 2.0, [AttackIntent.new(quick_throw_damage)])
	var attack_low_2_state: MoveState = MoveState.new("quick_throw 2", quick_throw_move, 1.0, [AttackIntent.new(quick_throw_damage)])
	var attack_low_3_state: MoveState = MoveState.new("quick_throw 3", quick_throw_move, 1.0, [AttackIntent.new(quick_throw_damage)])
	var attack_low_4_state: MoveState = MoveState.new("quick_throw 4", quick_throw_move, 1.0, [AttackIntent.new(quick_throw_damage)])
	var attack_high_state: MoveState = MoveState.new("dunk", dunk_move, 3.0, [AttackIntent.new(dunk_damage)])
	
	attack_low_state.next_state = attack_low_2_state
	attack_low_2_state.next_state = attack_low_3_state
	attack_low_3_state.next_state = attack_low_4_state
	attack_low_4_state.next_state = attack_high_state
	
	return MoveStateMachine.new([attack_low_state], attack_low_state)

func quick_throw_move() -> void:
	await AttackCommand.new(quick_throw_damage).from_enemy(self).targeting_all_opponents(combat_state).execute()

func dunk_move() -> void:
	await AttackCommand.new(dunk_damage).from_enemy(self).targeting_all_opponents(combat_state).execute()
