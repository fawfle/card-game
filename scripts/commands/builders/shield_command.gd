class_name ShieldCommand
## Commands for shields. Used as a builder.
##
## Builds a shield using chained methods, like tweens. NOT static like other commands. Execute with [method execute].

var shield_amount: float = 0
var priority: Constants.ShieldPriority = Constants.ShieldPriority.NONE

var creature: Creature = null

var total_duration_seconds: float = -1
var card_source: CardModel = null
var destroy_card_if_removed: bool = false

func _init(target_creature: Creature) -> void:
	creature = target_creature

func with_shield(amount: float) -> ShieldCommand:
	shield_amount = amount
	return self

func with_priority(shield_priority: Constants.ShieldPriority) -> ShieldCommand:
	priority = shield_priority
	return self

func from_card(card: CardModel, destroy_if_shield_removed: bool = true) -> ShieldCommand:
	card_source = card
	destroy_card_if_removed = destroy_if_shield_removed
	return self

func with_duration(duration_seconds: float) -> ShieldCommand:
	total_duration_seconds = duration_seconds
	return self

## Apply shield to the creature.
func execute() -> void:
	var shield: Shield = Shield.new(creature, shield_amount, priority)
	if card_source: shield.bind_to_card(card_source, destroy_card_if_removed)
	elif total_duration_seconds != -1: shield.set_duration(total_duration_seconds)
	
	CreatureCommand.add_shield(creature, shield, card_source)
