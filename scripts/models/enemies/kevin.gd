class_name Kevin extends EnemyModel

func get_max_hp() -> int: return 20

var damage_low: int = 2
var damage_high: int = 4

var shield: int = 3
var shield_duration: float = 5.0

func generate_move_state_machine() -> MoveStateMachine:
	var attack_low_state: MoveState = MoveState.new("TEST ATTACK", attack_low_move, 3.0, [AttackIntent.new(damage_low)])
	var shield_state: MoveState = MoveState.new("TEST SHIELD", shield_move, 2.0, [ShieldIntent.new(shield)])
	var attack_high_state: MoveState = MoveState.new("TEST ATTACK", attack_high_move, 3.0, [AttackIntent.new(damage_high)])
	
	attack_low_state.next_state = shield_state
	shield_state.next_state = attack_high_state
	
	return MoveStateMachine.new([attack_low_state, shield_state, attack_high_state], attack_low_state)

func attack_low_move():
	AttackCommand.new().from_enemy(self).targeting_all_opponents(combat_state).with_damage(damage_low).execute()

func attack_high_move():
	AttackCommand.new().from_enemy(self).targeting_all_opponents(combat_state).with_damage(damage_high).execute()

func shield_move():
	ShieldCommand.new(self.creature).with_shield(shield).with_duration(shield_duration).execute()
