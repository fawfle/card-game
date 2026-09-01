class_name RunManager
## Manages actual runs.
##
## Singleton accessed with static [member RunManager.instance]. Choosing instance of globals b/c why not, it makes it less editor dependent (plagiarism).

signal map_point_visited(map_point: MapPoint)

static var instance: RunManager = RunManager.new()

var run_state: RunState = null

## Do everything required to setup a new run.
func set_up_new_run(state: RunState):
	if run_state != null: push_error("cannot start new run while another run is active. Make sure to clear the state.")
	run_state = state

func enter_run():
	generate_map()
	
	MapScreen.instance.set_travel_enabled(true)
	MapScreen.instance.open()
	
	CombatManager.instance.start_combat_from_state(run_state, combat_state)

func generate_map() -> void:
	run_state.map = Map.new(run_state)
	MapScreen.instance.set_map(run_state.map)

func can_visit_map_point(map_point: MapPoint) -> bool:
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
		var combat_room: CombatRoom = CombatRoom.create_from_encounter(run_state, run_state.act.get_normal_encounters()[0])
		enter_room(combat_room)
	
	map_point_visited.emit(map_point)

## Enter a room. Not to be confused with [method enter_map_point] which is used for entering a point on the map.
func enter_room(room: CombatRoom) -> void:
	if run_state.current_room: run_state.current_room.exit()
	MapScreen.instance.close()
	room.enter(run_state)

## Enables the map screen and handles leaving a room.
func proceed_from_room() -> void:
	MapScreen.instance.set_travel_enabled(true)
	MapScreen.instance.open()
