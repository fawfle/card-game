class_name Teacher extends EnemyModel
## A basic enemy.

func get_max_hp() -> int: return 20

var damage_amount_with_shield: int = 2
var shield_amount: int = 3
var shield_duration: float = 5.0
var damage_amount: int = 3

func generate_move_state_machine() -> MoveStateMachine:
	var attack_and_shield_state: MoveState = MoveState.new("attack_and_shield", _attack_and_shield_move, 5.0, [AttackIntent.new(damage_amount_with_shield), ShieldIntent.new(shield_amount)])
	var attack_state: MoveState = MoveState.new("attack", _attack_move, 4.0, [AttackIntent.new(damage_amount)])
	attack_and_shield_state.next_state = attack_state
	
	return MoveStateMachine.new([attack_and_shield_state, attack_state], attack_and_shield_state)

func _attack_and_shield_move() -> void:
	# reflect order of intents.
	await AttackCommand.new(damage_amount_with_shield).from_enemy(self).targeting_all_opponents(combat_state).execute()
	ShieldCommand.new(creature).with_shield(shield_amount).with_duration(shield_duration).execute()

func _attack_move() -> void:
	await AttackCommand.new(damage_amount).from_enemy(self).targeting_all_opponents(combat_state).execute()
