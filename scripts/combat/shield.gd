class_name Shield
## Represents a shield for a creature.
##
## This class keeps track of information about a shield. Should be managed/manipulated by commands. [br][br]
## Avoid creating directly. Instead, use a [ShieldCommand].

## Emitted when the shield is finished for any reason.
signal shield_removed()

var creature: Creature

## Initial shield. When set, sets [member current_shield] to match.
var initial_shield: int = 0:
	set(value):
		initial_shield = value
		current_shield = value

## Is set when [member initial_shield] is set. TODO: make dynamic and stuff
var current_shield: int = 0

## Card that created this shield. Used to listen to card events.
var card_source: CardModel = null
var _destroy_card_if_removed: bool = false

var total_duration_seconds: float = -1

var _time_spent_in_play: float = -1

var _removed: bool = false

var _has_timeout_condition:
	get(): return card_source != null or total_duration_seconds != -1

var priority: Constants.ShieldPriority = Constants.ShieldPriority.NONE

func _init(target_creature: Creature, shield_amount: int, shield_priority: Constants.ShieldPriority) -> void:
	creature = target_creature
	initial_shield = shield_amount
	priority = shield_priority

## if [param destroy_card_if_broken] is true, the card will be destroyed if the shield is removed.
func bind_to_card(card: CardModel, destroy_card_if_removed: bool = true) -> Shield:
	if _has_timeout_condition: push_error("Shield already has a timeout condition")
	card_source = card
	card_source.exited_play.connect(on_card_source_exited)
	_destroy_card_if_removed = destroy_card_if_removed
	return self

func set_duration(duration_seconds: float) -> Shield:
	if card_source: push_error("Don't add duration to a shield bound to a card")
	total_duration_seconds = duration_seconds
	_time_spent_in_play = 0
	return self

## Add to the time in play. This method will remove the card from the creature if the time exceeds the play duration. [br][br]
## TODO: Add hooks? Could get scuffed with shields binded to cards. Could do a 2 way thing where they share a timer so effects can be generic.
func add_timeout_delta(delta: float) -> void:
	if card_source:
		push_warning("timeout doesn't apply to a shield bound to a card")
		return
	_time_spent_in_play += delta
	if _time_spent_in_play >= total_duration_seconds:
		remove_from_creature_internal()


func on_card_source_exited() -> void:
	remove_from_creature_internal()

# A bit scuffed, but [method remove_from_creature_internal] only removes the shield. This method handles extra things, but we can bypass them when needed.
func remove_from_creature() -> void:
	if _destroy_card_if_removed:
		CardCommand.remove_from_play(card_source)
	remove_from_creature_internal()

func remove_from_creature_internal():
	if _removed: return
	CreatureCommand.remove_shield(creature, self)
	_removed = true
	shield_removed.emit()

func get_duration() -> float:
	if card_source: return card_source.get_play_duration()
	return total_duration_seconds

func get_time_left() -> float:
	if not _has_timeout_condition: push_error("card that can't timeout")
	if card_source and card_source.card_play: return card_source.card_play.play_time_left
	return total_duration_seconds - _time_spent_in_play
