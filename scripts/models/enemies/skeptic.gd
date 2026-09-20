class_name Skeptic extends EnemyModel

func get_max_hp() -> int: return 20

var damage_amount: int = 3
var debuff_convincing_amount: int = -1

func generate_move_state_machine() -> MoveStateMachine:
	var debuff_convincing_state: MoveState = MoveState.new("DEBUFF CONVINCING", _debuff_convincing_move, 5.0, [EffectIntent.new(ConvincingEffect, debuff_convincing_amount, EffectIntent.TargetType.DEBUFF)])
	var attack_state: MoveState = MoveState.new("ATTACK", _attack_move, 5.0, [AttackIntent.new(damage_amount)])
	
	debuff_convincing_state.next_state = attack_state
	attack_state.next_state = attack_state
	
	return MoveStateMachine.new([attack_state, debuff_convincing_state], debuff_convincing_state)

func _attack_move() -> void:
	AttackCommand.new().from_enemy(self).targeting_all_opponents(combat_state).with_damage(damage_amount).execute()

func _debuff_convincing_move() -> void:
	EffectCommand.new(ConvincingEffect, RunManager.instance.run_state.player.creature, debuff_convincing_amount).from_creature(creature).execute()
