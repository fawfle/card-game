@abstract
class_name EffectModel extends AbstractModel
## Represents an effect a creature can have.
##
## Potency is represented by [member amount].


## How long the effect lasts. If -1, it is treated as permanent. (Unless it has a card_source). Access duration with [method get_duration]
var _duration: float = -1

## How long the effect will be in play.
var _time_left: float = -1

## set to true when the effect model is removed
var removed: bool = false

## The amount of times this effect is applied to the owner. To keep things simple, this should be the only real thing that changes an effect's effect.
var amount: int:
	set(value):
		assert_mutable()
		amount = value

@abstract func get_title() -> String

@abstract func get_icon() -> Texture2D

## a Visual only indicator of if the effect is "inactive", such as an effect that "triggers" every n actions.
func is_inactive() -> bool: return false

var is_permanent: bool:
	get(): return _duration == -1 and not card_source

## True if effect should handle its own timeout (i.e. with add_timeout_delta)
var has_delta_timeout: bool:
	get(): return _duration != -1 and not card_source

var _has_timeout_condition: bool:
	get(): return _duration != -1 or card_source

## The creature that this effect is applied to.
var owner: Creature
## The creature that applied this effect. Can be null.
var applier: Creature
## The card that applied this effect. Can be null.
var card_source: CardModel

## Apply to a creature. Avoid use. See [method CreatureCommand.apply_effect].
func apply_internal(owner_creature: Creature):
	assert_mutable()
	owner = owner_creature
	_time_left = _duration
	owner.apply_effect_internal(self)

func bind_to_card(card: CardModel) -> void:
	if _has_timeout_condition: push_error("Effect already has a timeout condition")
	card_source = card
	card_source.exited_play.connect(_on_card_source_exited)

func add_timeout_delta(delta: float) -> void:
	_time_left -= delta
	if _time_left <= 0:
		remove_from_creature_internal()

func remove_from_creature_internal() -> void:
	if removed: return
	owner.remove_effect_internal(self)
	removed = true

func add_time_left(delta: float) -> void:
	if not has_delta_timeout: push_error("cannot add time left to an effect that doesn't have a delta_timeout")
	_time_left += delta

## Decrement the amount and remove if it's 0. Could be seperated into a distinct "type" of effect model (like STS2 having "Counter" effects), but it should be fine.
func decrement_amount() -> void:
	amount -= 1
	if amount == 0:
		remove_from_creature_internal()

func get_duration() -> float:
	if card_source:
		if card_source.active_card_play: return card_source.active_card_play.play_duration
		else: push_error("card source should have an active cardplay")
	return _duration

func get_time_left() -> float:
	if not _has_timeout_condition: push_error("can't get time left on an effect that can't timeout")
	if card_source and card_source.active_card_play: return card_source.active_card_play.play_time_left
	return _time_left

func get_tool_tip() -> ToolTip:
	return ToolTip.new(get_title(), get_description())

## Get a specific description of the effect that can depend on the amount. See [method get_generic_description].
func get_description() -> String:
	return "broken description."

## Get a generic description of the effect that doesn't depend on the amount. See [method get_description].
static func get_generic_description() -> String:
	return "broken generic description."

func _on_card_source_exited() -> void:
	remove_from_creature_internal()
