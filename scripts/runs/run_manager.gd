class_name RunManager
## Manages actual runs.
##
## Singleton accessed with static [member RunManager.instance]. Choosing instance of globals b/c why not, it makes it less editor dependent (plagiarism).

signal map_point_visited(map_point: MapPoint)

static var instance: RunManager = RunManager.new()

var run_state: RunState = null

## Debug option to make every map point visitable
var can_visit_any_map_point: bool = false

## Do everything required to setup a new run.
func set_up_new_run(state: RunState):
	if run_state != null: push_error("cannot start new run while another run is active. Make sure to clear the state.")
	run_state = state

func enter_run():
	generate_map()
	
	MapScreen.instance.set_travel_enabled(true)
	MapScreen.instance.open()

func generate_map() -> void:
	run_state.map = Map.new(run_state, run_state.act)
	MapScreen.instance.set_map(run_state.map)

func can_visit_map_point(map_point: MapPoint) -> bool:
	if can_visit_any_map_point: return true
	var current_point_index: int = run_state.map.map_points.find(run_state.curent_map_point)
	var index: int = run_state.map.map_points.find(map_point)
	if index == current_point_index + 1:
		return true
	return false

## Enter a point on the map.
func enter_map_point(map_point: MapPoint) -> void:
	run_state.visit_map_point(map_point)
	if map_point.point_type == Constants.MapPointType.DEBATE:
		MapScreen.instance.set_travel_enabled(false)
		var encounter: EncounterModel = run_state.get_next_encounter_set().encounters.pick_random().clone_mutable_from_base()
		run_state.encounters_had_this_map += 1
		var combat_room: CombatRoom = CombatRoom.create_from_encounter(run_state, encounter)
		enter_room(combat_room)
	elif map_point.point_type == Constants.MapPointType.BOSS:
		MapScreen.instance.set_travel_enabled(false)
		var encounter: EncounterModel = run_state.act.boss_encounter_set.encounters.pick_random().clone_mutable_from_base()
		var combat_room: CombatRoom = CombatRoom.create_from_encounter(run_state, encounter)
		enter_room(combat_room)
	elif map_point.point_type == Constants.MapPointType.UPGRADE:
		MapScreen.instance.set_travel_enabled(false)
		var upgrade_room: UpgradeRoom = UpgradeRoom.new()
		enter_room(upgrade_room)
	
	map_point_visited.emit(map_point)

## Enter a room. Not to be confused with [method enter_map_point] which is used for entering a point on the map. [method enter_map_point] usually ends up calling this method.
func enter_room(room: AbstractRoom) -> void:
	if run_state.current_room: run_state.current_room.exit()
	MapScreen.instance.close()
	run_state.current_room = room
	room.enter(run_state)

## Enables the map screen and handles leaving a room.
func proceed_from_room() -> void:
	MapScreen.instance.set_travel_enabled(true)
	MapScreen.instance.open()

## Get a random card set (no dupes) from all the active card sets. The cards are mutable.
func get_random_card_set(count: int) -> Array[CardModel]:
	var card_set: Array[CardModel] = []
	var all_cards: Array[CardModel] = get_all_cards()
	if count > all_cards.size(): push_error("can't get a card set that's larger than the total number of cards in each cardpool")
	
	while card_set.size() < count:
		var random_card: CardModel = all_cards.pick_random()
		all_cards.erase(random_card)
		card_set.append(random_card.clone_mutable_from_base())
	
	return card_set

## Get a random upgrade from a random pool. The upgrade is mutable.
func get_random_upgrade() -> UpgradeModel:
	var all_upgrades: Array[UpgradeModel] = get_all_upgrades()
	if all_upgrades.size() == 0: push_error("there are no available upgrades! Make sure the run_state upgrade pools are set.")
	var upgrade: UpgradeModel = null
	while upgrade == null:
		var random_upgrade: UpgradeModel = all_upgrades.pick_random().clone_mutable()
		if random_upgrade.can_apply_to_any(run_state.player.deck):
			upgrade = random_upgrade
	return upgrade

# TODO: idk if I want card pools to overlap. If I do, make this account for it.
## Get every card in every card pool.
func get_all_cards() -> Array[CardModel]:
	var all_cards: Array[CardModel] = []
	for pool: CardPoolModel in run_state.active_card_pools:
		all_cards.append_array(pool.all_cards)
	return all_cards

func get_all_upgrades() -> Array[UpgradeModel]:
	var all_upgrades: Array[UpgradeModel] = []
	for pool: UpgradePoolModel in run_state.active_upgrade_pools:
		all_upgrades.append_array(pool.all_upgrades)
	return all_upgrades
