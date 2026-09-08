class_name CombatManager
## Manages combats.
##
## Singleton accessed with static [member CombatManager.instance].

signal combat_setup_completed(state: CombatState)
signal combat_started(state: CombatState)
## Emitted when the combat is ended, either by dying or winning.
signal combat_ended()
signal combat_won()

static var instance: CombatManager = CombatManager.new()

var combat_state: CombatState = null

var is_in_progress: bool = false
var is_over_or_completing: bool:
	get(): return not is_in_progress or is_combat_won()

## Called internally by [method start_combat] to set up combat. Organizational.
func _set_up_combat_internal(state: CombatState) -> void:
	if combat_state != null: push_error("Cannot start combat if another one is active. Make sure to clear/reset the state.")
	combat_state = state
	for player: Player in combat_state.get_players():
		player.reset_combat_state()
		player.populate_combat_state(combat_state)
	for enemy: EnemyModel in combat_state.get_enemy_models():
		enemy.set_up_for_combat()
	combat_setup_completed.emit(state)

## Called internally by [method start_combat] to begin combat. Organizational. Begins combat and starts running things.
func _begin_combat_internal() -> void:
	for player: Player in combat_state.get_players():
		CardPileCommand.draw(player, player.player_combat_state.get_initial_card_count())
	
	is_in_progress = true
	start_combat_manager_process()

## Starts a run from a combat state.
func start_combat_from_state(run_state: RunState, state: CombatState) -> void:
	var room: CombatRoom = CombatRoom.create_from_state(state)
	start_combat(run_state, room)

## Starts a run from a combat room. Performs necessary setup to actually start the combat, including loading the room.
func start_combat(run_state: RunState, room: CombatRoom) -> void:
	var combat_room_node: CombatRoomNode = CombatRoomNode.create(room)
	RunNode.instance.set_current_room(combat_room_node)
	room.combat_state.add_player(run_state.player)
	_set_up_combat_internal(room.combat_state)
	combat_room_node.ui.activate(combat_state)
	
	_begin_combat_internal()
	combat_started.emit(combat_state)

func lose_combat() -> void:
	is_in_progress = false
	combat_ended.emit()

## Check if combat is over.
func check_if_combat_ended() -> bool:
	if is_combat_won():
		win_combat_internal()
	
	return is_in_progress

func is_combat_won() -> bool:
	return combat_state.enemies.is_empty()

## Ends combat in a WINNING state.
func win_combat_internal() -> void:
	is_in_progress = false
	combat_ended.emit()
	combat_won.emit()
	print("COMPLETED COMBAT INTERNAL")

## resets the combatmanager for a new state
func reset() -> void:
	is_in_progress = false
	if not combat_state: return
	for creature: Creature in combat_state.get_all_creatures():
		creature.reset()
	combat_state = null

# NOTE: This may be verbose to handle each category of things separately (players, enemies, creatures), but for now it seems the most "organized".
## A process loop for the combat manager. Currently, only serves to update player draw timer.
func start_combat_manager_process() -> void:
	while not is_over_or_completing:
		await RunNode.instance.get_tree().process_frame
		var delta: float = RunNode.instance.get_process_delta_time()
		for player: Player in combat_state.get_players():
			player.player_combat_state.combat_manager_process(delta)
		
		for enemy: EnemyModel in combat_state.get_enemy_models():
			enemy.move_state_machine.add_state_time_delta_internal(delta)
			if enemy.should_perform_move():
				enemy.perform_move()
		
		for creature: Creature in combat_state.get_all_creatures():
			creature.combat_process(delta)
