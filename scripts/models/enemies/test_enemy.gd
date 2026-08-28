class_name TestEnemy extends EnemyModel

func get_max_hp() -> int: return 25

var damage: int = 5
var shield: int = 5

func generate_move_state_machine() -> MoveStateMachine:
	var attack_state: MoveState = MoveState.new("TEST ATTACK", attack_move, 1.0, [AttackIntent.new(damage)])
	var shield_state: MoveState = MoveState.new("TEST SHIELD", shield_move, 1.0, [ShieldIntent.new(shield)])
	
	attack_state.next_state = shield_state
	
	return MoveStateMachine.new([attack_state, shield_state], attack_state)

func attack_move():
	AttackCommand.new().from_enemy(self).targeting_all_opponents(combat_state).with_damage(damage).execute()

func shield_move():
	ShieldCommand.new(self.creature).with_shield(shield).with_duration(5.0).execute()
