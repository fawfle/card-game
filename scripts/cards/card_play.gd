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

func stop():
	play_time_left = 0.0
