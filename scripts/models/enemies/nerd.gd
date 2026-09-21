class_name Nerd extends EnemyModel
## Attack window between shields

func get_max_hp() -> int: return 24

var retaliate_amount: int = 2

var shield_amount: int = 5
var shield_duration: float = 4.5

var damage: int = 7
var attack_and_shield_shield_amount: int = 3
var attack_and_shield_shield_duration: float = 3.0

func generate_move_state_machine() -> MoveStateMachine:
	var apply_retaliate_state: MoveState = MoveState.new("apply_retaliate", apply_retaliate_move, 1.5, [EffectIntent.new(RetaliateEffect, retaliate_amount, EffectIntent.TargetType.BUFF)])
	var shield_state: MoveState = MoveState.new("shield", shield_move, 4.0, [ShieldIntent.new(shield_amount)])
	var attack_state: MoveState = MoveState.new("attack_and_shield", attack_and_shield_move, 5.0, [ShieldIntent.new(attack_and_shield_shield_amount), AttackIntent.new(damage)])
	# var shield_state_fast: MoveState = MoveState.new("shield_fast", shield_move, 2.0, [ShieldIntent.new(shield_amount)])
	# alternate shield and damage so the attack window is near the end of the attack state
	
	apply_retaliate_state.next_state = shield_state
	shield_state.next_state = attack_state
	attack_state.next_state = shield_state
	# attack_state.next_state = shield_state_fast
	# shield_state_fast.next_state = shield_state
	
	return MoveStateMachine.new([apply_retaliate_state, shield_state], apply_retaliate_state)

func apply_retaliate_move() -> void:
	EffectCommand.new(RetaliateEffect, creature, retaliate_amount).execute()

func shield_move() -> void:
	ShieldCommand.new(creature).with_shield(shield_amount).with_duration(shield_duration).with_priority(Constants.ShieldPriority.NONE).execute()

func attack_and_shield_move() -> void:
	ShieldCommand.new(creature).with_shield(attack_and_shield_shield_amount).with_duration(attack_and_shield_shield_duration).with_priority(Constants.ShieldPriority.NONE).execute()
	AttackCommand.new().from_enemy(self).with_damage(damage).targeting_all_opponents(combat_state).execute()
