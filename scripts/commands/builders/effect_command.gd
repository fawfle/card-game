class_name EffectCommand
## Command to create effects. Used as a builder.
##
## Builds an effect using chained methods, like tweens. NOT static like other commands. Execute with [method execute] and use [code]await[/code].
## Also has static methods to modify effects.

var _type: Script
var _target: Creature
var _amount: int

var _duration: float = -1

var _applier: Creature = null
var _card_source: CardModel = null

func _init(type: Script, target: Creature, amount: int) -> void:
	_type = type
	_target = target
	_amount = amount

## Sets the applier to be a specific creature. Do not need to call if another "from" method is used.
func from_creature(applier: Creature) -> EffectCommand:
	if _applier: push_error("effect command already has an applier")
	_applier = applier
	return self

## Sets the applier and card_source to be a card. Do not need to call other "from" methods like [method from_creature]. NOTE: WILL BIND EFFECT TO CARD!!
func from_card(card_source: CardModel) -> EffectCommand:
	if _applier: push_error("effect command already has an applier")
	_card_source = card_source
	_applier = card_source.owner.creature
	return self

## Gives an effect a duration to timeout.
func with_duration(duration: float) -> EffectCommand:
	_duration = duration
	return self

func execute() -> void:
	var effect: EffectModel = ModelDb.effect(_type).clone_mutable_from_base()
	effect.amount = _amount
	if _duration != -1: effect._duration = _duration
	if _card_source: effect.bind_to_card(_card_source)
	CreatureCommand.apply_effect(_target, effect, _applier, _card_source)


## Decrement the amount and remove if it's 0. Could be seperated into a distinct "type" of effect model (like STS2 having "Counter" effects), but it should be fine.
static func decrement_amount(effect: EffectModel) -> void:
	modify_amount(effect, -1)

static func modify_amount(effect: EffectModel, offset: int) -> void:
	effect.amount += offset
	# TODO: add more conditions (mainly for effects that are always non-negative)
	if effect.amount == 0:
		effect.remove_from_creature()
