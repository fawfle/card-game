class_name BoredMember extends EnemyModel

func get_max_hp() -> int: return 35

var vote_no_damage: int = 10
var get_out_damage: int = 6
var get_out_block: int = 1

func on_combat_start() -> void:
	EffectCommand.new(IrritableEffect, creature, 1).from_creature(creature).with_duration(8).execute()

func generate_move_state_machine() -> MoveStateMachine:
	var tired_state: MoveState = MoveState.new("TIRED", tired_move, 10.0, [WaitIntent.new()])
	var vote_no_state: MoveState = MoveState.new("VOTE_NO", vote_no_move, 5.0, [AttackIntent.new(10), EffectIntent.new(IrritableEffect, 1, EffectIntent.TargetType.BUFF)])
	var wait_state: MoveState = MoveState.new("WAIT", wait_move, 5.0, [WaitIntent.new()])
	var get_out_state: MoveState = MoveState.new("GET OUT", get_out_move, 6.0, [AttackIntent.new(get_out_damage), ShieldIntent.new(get_out_block)])
	
	tired_state.next_state = vote_no_state
	vote_no_state.next_state = wait_state
	wait_state.next_state = get_out_state
	get_out_state.next_state = get_out_state
	
	tired_state.next_state = vote_no_state
	
	return MoveStateMachine.new([tired_state, vote_no_state, wait_state, get_out_state], tired_state)

func tired_move() -> void:
	pass

func vote_no_move() -> void:
	AttackCommand.new().from_enemy(self).with_damage(vote_no_damage).targeting_all_opponents(combat_state).execute()
	EffectCommand.new(IrritableEffect, creature, 1).from_creature(creature).with_duration(5.0).execute()

func wait_move() -> void:
	pass

func get_out_move() -> void:
	AttackCommand.new().from_enemy(self).with_damage(get_out_damage).targeting_all_opponents(combat_state).execute()
	ShieldCommand.new(creature).with_shield(get_out_block).with_priority(Constants.ShieldPriority.PERMANENT).execute()
