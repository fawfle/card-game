class_name Student extends EnemyModel
## A basic enemy.

func get_max_hp() -> int: return 20

var damage_amount: int = 1
var convincing_amount: int = 1

func generate_move_state_machine() -> MoveStateMachine:
	var attack_state: MoveState = MoveState.new("ATTACK", _attack_move, 2.0, [AttackIntent.new(damage_amount)])
	var study_state: MoveState = MoveState.new("STUDY", _study_move, 5.0, [EffectIntent.new(ConvincingEffect, convincing_amount)])
	
	attack_state.next_state = study_state
	
	return MoveStateMachine.new([attack_state], attack_state)

func _attack_move() -> void:
	AttackCommand.new().from_enemy(self).targeting_all_opponents(combat_state).with_damage(damage_amount).execute()

func _study_move() -> void:
	EffectCommand.new(ConvincingEffect, creature, convincing_amount).from_creature(creature).execute()
