class_name Turtle extends EnemyModel
## Enemy that blocks a lot.

func get_max_hp() -> int: return 14

var shield_amount: int  = 2
var damage_amount: int = 8

func generate_move_state_machine() -> MoveStateMachine:
	var shield_a_state: MoveState = MoveState.new("shield_a", _shield_move, 2.0, [ShieldIntent.new(shield_amount)])
	var shield_b_state: MoveState = MoveState.new("shield_b", _shield_move, 4.0, [ShieldIntent.new(shield_amount)])
	var shield_c_state: MoveState = MoveState.new("shield_b", _shield_move, 4.0, [ShieldIntent.new(shield_amount)])
	var attack_state: MoveState = MoveState.new("attack", _attack_move, 5.0, [AttackIntent.new(damage_amount)])
	
	shield_a_state.next_state = shield_b_state
	shield_b_state.next_state = shield_c_state
	shield_c_state.next_state = attack_state
	
	return MoveStateMachine.new([shield_a_state, shield_b_state, shield_c_state], shield_a_state)

func _shield_move() -> void:
	ShieldCommand.new(self.creature).with_shield(shield_amount).execute()

func _attack_move() -> void:
	AttackCommand.new().from_enemy(self).targeting_all_opponents(combat_state).with_damage(damage_amount).execute()
