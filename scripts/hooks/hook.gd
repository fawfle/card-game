class_name Hook extends StaticClass
## Provides static methods for calling hooks.
##
## Gameplay event Hooks should primarily be used in Commands, though some effects, like modify, are supposed to be called elsewhere. [br][br]
## Static class.

# ignore warning since default callbacks are not considered Coroutines.
@warning_ignore_start("redundant_await")

## Helper function to get combat hook listeners ONLY while combat is explicitly active.
## Essentially a guard clause that can prevent a specific hook from running if combat is inactive.
## This is present in [Hook] rather than [CombatState] because that's what STS2 does (and I guess it preserves the "purity" of [CombatState]).
static func get_active_combat_hook_listeners(combat_state: CombatState) -> Array[AbstractModel]:
	return []

## See [method AbstractModel.before_attack].
static func before_attack(combatState: CombatState, attack) -> void:
	for model: AbstractModel in combatState:
		await model.before_attack(attack)

## See [method AbstractModel.after_attack].
static func after_attack(combatState: CombatState, attack) -> void:
	for model: AbstractModel in combatState:
		await model.after_attack(attack)

## See [method AbstractModel.after_card_drawn].
static func after_card_drawn(combatState: CombatState, card) -> void:
	for model: AbstractModel in combatState:
		await model.after_card_drawn(card)

## See [method AbstractModel.after_card_discarded].
static func after_card_discarded(combatState: CombatState, card) -> void:
	for model: AbstractModel in CombatState:
		await model.after_card_discarded(card)

## See [method AbstractModel.after_card_changes_piles].
static func after_card_changes_piles(card, old_pile) -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after the players draw pile is shuffled. [br][br]
## Combat only.
static func after_shuffle() -> void:
	push_error("not implemented")


# WARNING: UNUSED
## Runs after the players hand becomes empty. [br][br]
## Combat only.
static func after_hand_emptied() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs before a card is played. [br][br]
## Combat only.
static func before_card_played(combat_state: CombatState, card_play: CardPlay) -> void:
	for listener: AbstractModel in combat_state.get_hook_listeners():
		await listener.before_card_played(card_play)

# WARNING: UNUSED
## Runs after a card is played. [br][br]
## Combat only.
static func after_card_played(combat_state: CombatState, card_play: CardPlay) -> void:
	for listener: AbstractModel in combat_state.get_hook_listeners():
		await listener.after_card_played(card_play)

# WARNING: UNUSED
## Runs before a card exits play. [br][br]
## NOTE: This will run even if the card is instant, though it should execute immediately. [br][br]
## Combat only.
static func before_card_exits(card) -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after a card exits play. [br][br]
## NOTE: This will run even if the card is instant, though it should execute immediately. [br][br]
## Combat only.
static func after_card_exits(card) -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs before a card is removed from the deck.
static func before_card_removed(card) -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs before combat starts.
static func before_combat_start() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after combat ends.
static func after_combat_end() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after any creature's HP is changed for any reason (damage, heal, etc.). Can happen out of combat.
static func after_current_hp_changed(creature, delta) -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs before damage is dealt to a creature (regardless of actual damage).
static func before_damage_dealt() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after damage is dealt to a creature (regardless of actual damage). [br][br]
## Different from [method after_damage_taken] since it runs regardless of the creature's state. Also semantics.
static func after_damage_given() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after damage is taken by a creature (regardless of actual damage). [br][br]
## Different from [method after_damage_given] since it will NOT run if the creature dies. For example, this can be to avoid updating statuses. Also semantics.
static func after_damage_taken() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs before a creature dies.
static func before_death() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after a creature dies.
static func after_death() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after ethos is spent. [br][br]
## Combat only.
static func after_ethos_spent() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after logos is spent. [br][br]
## Combat ony.
static func after_logos_spent() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## See [method AbstractModel.modify_max_pathos]
static func modify_max_pathos(max_pathos: float) -> float:
	return max_pathos

# WARNING: UNUSED
## See [method AbstractModel.modify_max_logos]
static func modify_max_logos(max_logos: float) -> float:
	return max_logos

# WARNING: UNUSED
static func modify_initial_card_count(initial_card_count: float) -> float:
	return initial_card_count

# WARNING: UNUSED, unimplemented
static func modify_draw_time(draw_time: float) -> float:
	return draw_time

static func modify_draw_time_delta(delta: float) -> float:
	return delta

# WARNING: UNUSED, unimplemented
static func modify_move_time(move_time: float) -> float:
	return move_time

# WARNING: UNUSED, unimplemented
static func modify_move_time_delta(delta: float) -> float:
	return delta

# WARNING: UNUSED and unfinished
## modify the amount that will be dealt. Additive effects are applied first, followed by multiplicative effects. [br][br]
## See [method AbstractModel.modify_damage_additive] and [method AbstractModel.modify_damage_multiplicative]. [br][br]
## NOTE: this function, and most modify functions, use floats instead of ints for calculations. The value will always be converted to the correct type when used.
## This note is not included on other modify functions b/c I'm lazy, but it applies to them as well.
static func modify_damage(run_state: RunState, combat_state: CombatState, target: Creature, dealer: Creature, amount: float, card_source: CardModel) -> float:
	var damage: float = amount
	for model: AbstractModel in run_state.get_hook_listeners(combat_state):
		damage += model.modify_damage_additive(target, dealer, damage, card_source)
	for model: AbstractModel in  run_state.get_hook_listeners(combat_state):
		damage *= model.modify_damage_multiplicative(target, dealer, damage, card_source)
	return damage

# WARNING: UNUSED
## Modify a shield. Additive effects are applied first, followed by multiplicative effects. [br][br]
## See [method AbstractModel.modify_shield_additive] and [method AbstractModel.modify_shield_multiplicative].
static func modify_shield(combat_state: CombatState, creature: Creature, shield: Shield, card_source: CardModel) -> Shield:
	var shield_amount = shield.current_shield
	for model: AbstractModel in combat_state.get_hook_listeners():
		shield_amount += model.modify_shield_additive(creature, shield_amount, card_source)
	for model: AbstractModel in combat_state.get_hook_listeners():
		shield_amount *= model.modify_shield_multiplicative(creature, shield_amount, card_source)
	
	shield.current_shield = shield_amount
	
	return shield
