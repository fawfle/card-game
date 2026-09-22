class_name ClubPresident extends EnemyModel

func get_max_hp() -> int: return 25

var damage: int = 8

func generate_move_state_machine() -> MoveStateMachine:
	var attack_state: MoveState = MoveState.new("attack", attack_move, 9.0, [AttackIntent.new(damage)])
	
	return MoveStateMachine.new([attack_state], attack_state)

func attack_move() -> void:
	await AttackCommand.new(damage).from_enemy(self).targeting_all_opponents(combat_state).execute()
