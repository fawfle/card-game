class_name RunState
## Manages the state of an entire run.

var player: Player = null

var _acts: Array[ActModel] = []
var act: ActModel = null
var map: Map = null
var current_room: CombatRoom = null

## Keep track of what map points the player has visited.
var visited_map_points: Array[MapPoint] = []
## The current map point the player is at 
var curent_map_point: MapPoint = null

## TODO: implement seeds.
func _init(player_: Player, acts: Array[ActModel], seed: String) -> void:
	player = player_
	player.run_state = self
	
	_acts = acts
	act = _acts[0]

## Updates variables that track MapPoints.
func visit_map_point(map_point) -> void:
	curent_map_point = map_point
	visited_map_points.push_back(map_point)

## Get all hook listeners in the run_state. Can be passed an optional [param child_combat_state] to add all CombatState listeners to the listeners.
func get_hook_listeners(child_combat_state: CombatState) -> Array[AbstractModel]:
	var listeners: Array[AbstractModel] = []
	
	# listeners.append(player)
	for card: CardModel in player.deck.cards:
		listeners.push_back(card)
	
	if child_combat_state:
		listeners.append_array(child_combat_state.get_hook_listeners())
	
	return listeners
