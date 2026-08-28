class_name RunState
## Manages the state of an entire run.

var player: Player = null

## TODO: implement seeds.
func _init(player_: Player, seed: String) -> void:
	player = player_
	player.run_state = self

## Get all hook listeners in the run_state. Can be passed an optional [param child_combat_state] to add all CombatState listeners to the listeners.
func get_hook_listeners(child_combat_state: CombatState) -> Array[AbstractModel]:
	var listeners: Array[AbstractModel] = []
	
	# listeners.append(player)
	for card: CardModel in player.deck.cards:
		listeners.push_back(card)
	
	if child_combat_state:
		listeners.append_array(child_combat_state.get_hook_listeners())
	
	return listeners
