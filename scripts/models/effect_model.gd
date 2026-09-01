@abstract
class_name EffectModel extends AbstractModel

## How long the effect lasts. If -1, it is treated as permanent.
var duration: float = -1

## How long the effect will be in play.
var time_left: float = -1

## The amount of times this effect is applied to the owner. To keep things simple, this should be the only real thing that changes an effect's effect.
var amount: int:
	set(value):
		assert_mutable()
		amount = value

@abstract func get_title() -> String

@abstract func get_icon() -> Texture2D

var is_temporary: bool:
	get(): return duration != -1

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
	time_left = duration
	owner.apply_effect_internal(self)

func add_timeout_delta(delta: float) -> void:
	time_left -= delta
	if time_left <= 0:
		owner.remove_effect_internal(self)

func get_hover_tip() -> ToolTip:
	return ToolTip.new(get_title(), get_description())

func get_description() -> String:
	return "broken description."
