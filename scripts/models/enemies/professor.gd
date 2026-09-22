class_name Professor extends EnemyModel

func get_max_hp() -> int: return 35

var starting_class_shield_block: int = 20
var starting_class_shield_duration: float = 20.0

var teach_a_lesson_damage: int = 9

var prepare_convincing_amount: int = 1

func generate_move_state_machine() -> MoveStateMachine:
	var starting_class_state: MoveState = MoveState.new("STARTING_CLASS", starting_class_move, 8.0, [ShieldIntent.new(starting_class_shield_block)])
	var teach_a_lesson_state: MoveState = MoveState.new("TEACH_A_LESSON", teach_a_lesson_move, 6.0, [AttackIntent.new(teach_a_lesson_damage)])
	var prepare_state: MoveState = MoveState.new("PREPARE", prepare_move, 5.0, [EffectIntent.new(ConvincingEffect, prepare_convincing_amount, EffectIntent.TargetType.BUFF)])
	
	starting_class_state.next_state = teach_a_lesson_state
	teach_a_lesson_state.next_state = prepare_state
	prepare_state.next_state = teach_a_lesson_state
	
	return MoveStateMachine.new([starting_class_state, teach_a_lesson_state, prepare_state], starting_class_state)

func starting_class_move() -> void:
	ShieldCommand.new(creature).with_shield(starting_class_shield_block).with_duration(starting_class_shield_duration).with_priority(Constants.ShieldPriority.NONE).execute()

func teach_a_lesson_move() -> void:
	await AttackCommand.new(teach_a_lesson_damage).from_enemy(self).targeting_all_opponents(combat_state).execute()

func prepare_move() -> void:
	EffectCommand.new(ConvincingEffect, creature, prepare_convincing_amount).from_creature(creature).execute()
