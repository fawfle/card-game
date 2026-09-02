class_name CardPlay
## Stores information about a card being played.
##
## To instantiate, see [method create_from_properties]

var card: CardModel
## The target of the CardPlay. NOTE: Currently, gets decided by the card's [enum Constants.TargetType].
var target: Creature

## The amount of time in seconds the card remains in play. Also see [member play_time_left].
var play_duration: float
## A timer keeping track of the seconds this card remains in play. MUST be updated externally.
var play_time_left: float

var stopped: bool = false
var cancelled: bool = false
var cancelled_creature_source: Creature

## This could be dumb, idk. Plagiarism. Template dictionary:
## [codeblock]
##{
##    "card": CardModel
##    "target": Creature
##    "play_duration": float
##}
## [/codeblock]
static func create_from_properties(dictionary: Dictionary[String, Variant]) -> CardPlay:
	var card_play: CardPlay = CardPlay.new()
	card_play.card = dictionary["card"]
	card_play.target = dictionary["target"]
	card_play.play_duration = dictionary["play_duration"]
	card_play.play_time_left = card_play.play_duration
	return card_play

## Pushes an error if the target is null
func assert_has_target():
	if target == null: push_error("target expected to not be null")

## Simply stops the CardPlay. Does not trigger timeout.
func stop():
	stopped = true

# TODO: Add more sources
## Cancels a CardPlay and invokes events. Not to be confused with [method stop].
func cancel(creature_soure: Creature) -> void:
	cancelled = true
	cancelled_creature_source = creature_soure

func is_active() -> bool:
	return play_time_left > 0 and not stopped and not cancelled
