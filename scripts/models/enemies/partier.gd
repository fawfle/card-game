class_name Partier extends EnemyModel

func get_max_hp() -> int: return 25

var damage_one: int = 1
var damage_two: int = 3
var damage_three: int = 5
var damage_four: int = 8

func generate_move_state_machine() -> MoveStateMachine:
	var attack_one_state: MoveState = MoveState.new("attack_one", attack_one_move, 4.0, [AttackIntent.new(damage_one)])
	var attack_two_state: MoveState = MoveState.new("attack_otwo", attack_two_move, 4.0, [AttackIntent.new(damage_two)])
	var attack_three_state: MoveState = MoveState.new("attack_three", attack_three_move, 4.0, [AttackIntent.new(damage_three)])
	var attack_four_state: MoveState = MoveState.new("attack_four", attack_four_move, 4.0, [AttackIntent.new(damage_four)])
	
	attack_one_state.next_state = attack_two_state
	attack_two_state.next_state = attack_three_state
	attack_three_state.next_state = attack_four_state
	
	return MoveStateMachine.new([attack_one_state, attack_two_state, attack_three_state, attack_four_state], attack_one_state)

# Separate for when vfx get added

func attack_one_move() -> void:
	await AttackCommand.new(damage_one).from_enemy(self).targeting_all_opponents(combat_state).execute()

func attack_two_move() -> void:
	await AttackCommand.new(damage_two).from_enemy(self).targeting_all_opponents(combat_state).execute()

func attack_three_move() -> void:
	await AttackCommand.new(damage_three).from_enemy(self).targeting_all_opponents(combat_state).execute()

func attack_four_move() -> void:
	await AttackCommand.new(damage_four).from_enemy(self).targeting_all_opponents(combat_state).execute()
