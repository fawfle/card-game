class_name CombatStateTracker
## Tracks when the combat_state changes.
##
## From STS2, I like the organization of tracking changes in a separate class. Use [signal combat_state_changed] for things that need to update when
## anything changes, like card previews. TODO: currently does nothing and is unused.

signal combat_state_changed(combat_state: CombatState)

var _combat_manager: CombatManager
var _combat_state: CombatState

var queued: bool = false

func _init(combat_manager: CombatManager) -> void:
	_combat_manager = combat_manager

## TODOs
func subscribe_to_combat_state(combat_state: CombatState) -> void:
	_combat_state = combat_state

## TODO
func subscribe_to_card(card: CardModel) -> void:
	pass

## TODO
func subscribe_to_creature(creature: Creature) -> void:
	pass

## TODO
func subscribe_to_pile(pile: CardPile) -> void:
	pass

func queue_combat_state_changed() -> void:
	if queued: return
	queued = true
	await RunNode.instance.get_tree().process_frame
	queued = false
	combat_state_changed.emit(_combat_state)
