class_name Athlete extends EnemyModel

func get_max_hp() -> int: return 30

var damage_low: int = 1
var damage_high: int = 3

func generate_move_state_machine() -> MoveStateMachine:
	# TODO: possibly add a repeater state thing
	var attack_low_state: MoveState = MoveState.new("attack_low", attack_low_move, 2.0, [AttackIntent.new(damage_low)])
	var attack_low_2_state: MoveState = MoveState.new("attack_low 2", attack_low_move, 1.0, [AttackIntent.new(damage_low)])
	var attack_low_3_state: MoveState = MoveState.new("attack_low 3", attack_low_move, 1.0, [AttackIntent.new(damage_low)])
	var attack_low_4_state: MoveState = MoveState.new("attack_low 4", attack_low_move, 1.0, [AttackIntent.new(damage_low)])
	var attack_high_state: MoveState = MoveState.new("attack_high", attack_low_move, 3.0, [AttackIntent.new(damage_high)])
	
	attack_low_state.next_state = attack_low_2_state
	attack_low_2_state.next_state = attack_low_3_state
	attack_low_3_state.next_state = attack_low_4_state
	attack_low_4_state.next_state = attack_high_state
	
	return MoveStateMachine.new([attack_low_state], attack_low_state)

func attack_low_move() -> void:
	AttackCommand.new().from_enemy(self).with_damage(damage_low).targeting_all_opponents(combat_state).execute()

func attack_high_move() -> void:
	AttackCommand.new().from_enemy(self).with_damage(damage_high).targeting_all_opponents(combat_state).execute()
