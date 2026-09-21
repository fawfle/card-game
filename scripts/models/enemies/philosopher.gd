class_name Philosopher extends EnemyModel

func get_max_hp() -> int: return 30

var intimidate_amount: int = 4

var diatribe_damage: int = 15
var insight_damage: int = 3

func generate_move_state_machine() -> MoveStateMachine:
	var intimidate_state: MoveState = MoveState.new("INTIMIDATE", intimidate_move, 5.0, [EffectIntent.new(Intimidated, intimidate_amount, EffectIntent.TargetType.DEBUFF)])
	var diatribe_state: MoveState = MoveState.new("DIATRIBE", diatribe_move, 15.0, [AttackIntent.new(diatribe_damage)])
	var insight_state: MoveState = MoveState.new("DIATRIBE", insight_move, 3.0, [AttackIntent.new(insight_damage)])
	
	intimidate_state.next_state = diatribe_state
	diatribe_state.next_state = insight_state
	insight_state.next_state = diatribe_state
	
	return MoveStateMachine.new([intimidate_state], intimidate_state)

func intimidate_move() -> void:
	EffectCommand.new(Intimidated, RunManager.instance.run_state.player.creature, intimidate_amount).execute()

func diatribe_move() -> void:
	AttackCommand.new().from_enemy(self).with_damage(diatribe_damage).targeting_all_opponents(combat_state).execute()

func insight_move() -> void:
	AttackCommand.new().from_enemy(self).with_damage(insight_damage).targeting_all_opponents(combat_state).execute()
