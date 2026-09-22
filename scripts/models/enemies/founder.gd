class_name Founder extends EnemyModel

func get_max_hp() -> int: return 50

var motto_damage: int = 5
var motto_hit_count: int = 2
var speech_damage: int = 6
var defend_institution_block: int = 5
var defend_institution_shield_duration: float = 8.0

func generate_move_state_machine() -> MoveStateMachine:
	var motto_state: MoveState = MoveState.new("MOTTO", motto_move, 6.0, [AttackIntent.new(motto_damage).with_hit_count(2)])
	var speech_state: MoveState = MoveState.new("SPEECH", speech_move, 4.0, [AttackIntent.new(speech_damage)])
	var defend_institution_state: MoveState = MoveState.new("DEFEND_INSTITUTION", defend_institution_move, 5.0, [ShieldIntent.new(defend_institution_block)])
	var expand_state: MoveState = MoveState.new("EXPAND", expand_move, 5.0, [EffectIntent.new(ConvincingEffect, 1, EffectIntent.TargetType.BUFF), EffectIntent.new(SupportEffect, 1, EffectIntent.TargetType.BUFF)])
	
	motto_state.next_state = speech_state
	speech_state.next_state = defend_institution_state
	defend_institution_state.next_state = expand_state
	
	return MoveStateMachine.new([motto_state, speech_state, defend_institution_state], motto_state)

func motto_move() -> void:
	await AttackCommand.new(motto_damage).from_enemy(self).with_hit_count(motto_hit_count).targeting_all_opponents(combat_state).execute()

func speech_move() -> void:
	await AttackCommand.new(speech_damage).from_enemy(self).targeting_all_opponents(combat_state).execute()

func defend_institution_move() -> void:
	await ShieldCommand.new(creature).with_shield(defend_institution_block).with_duration(defend_institution_shield_duration).execute()

func expand_move() -> void:
	await EffectCommand.new(ConvincingEffect, creature, 1).from_creature(creature).execute()
	await EffectCommand.new(SupportEffect, creature, 1).from_creature(creature).execute()
