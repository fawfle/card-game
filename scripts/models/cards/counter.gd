class_name Counter extends CardModel
## Basic counter.

func get_icon() -> Texture2D: return preload("res://assets/icons/shield_reflect.webp")

var shield_amount: int = 2
var counter_amount: int = 5

func get_play_duration() -> float: return 1.00

func get_pathos_cost() -> int: return 1

func get_description() -> String: return "Gain %d shield. If the shield is broken, deal %d damage." % [shield_amount, counter_amount]

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

func on_play(card_play: CardPlay) -> void:
	ShieldCommand.new(card_play.card.owner.creature).with_shield(shield_amount).from_card(self).with_priority(Constants.ShieldPriority.COUNTER).execute()

func on_cancelled(creature_source: Creature) -> void:
	if creature_source.enemy:
		AttackCommand.new().from_card(self).targeting(creature_source).with_damage(counter_amount).execute()
		VfxCommand.play_on_creature_front(owner.creature, preload("res://scenes/vfx/objection.tscn"))
