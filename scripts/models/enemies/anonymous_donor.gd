class_name AnonymousDonor extends EnemyModel

func get_max_hp() -> int: return 18

var from_the_shadows_damage: int = 10
var donation_heal: int = 1

func on_combat_start() -> void:
	EffectCommand.new(ConcealedEffect, creature, 999).from_creature(creature).execute()

func generate_move_state_machine() -> MoveStateMachine:
	var from_the_shadows_state: MoveState = MoveState.new("FROM_THE_SHADOWS", from_the_shadows_move, 5.0, [AttackIntent.new(from_the_shadows_damage)])
	var donation_state: MoveState = MoveState.new("DONATION", donation_move, 7.0, [HealIntent.new(donation_heal)])
	
	from_the_shadows_state.next_state = donation_state
	
	return MoveStateMachine.new([from_the_shadows_state, donation_state], from_the_shadows_state)

func from_the_shadows_move() -> void:
	await AttackCommand.new(from_the_shadows_damage).from_enemy(self).targeting_all_opponents(combat_state).execute()

func donation_move() -> void:
	CreatureCommand.heal(creature, donation_heal)
