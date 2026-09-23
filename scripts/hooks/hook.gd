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
## I'm not using it, at least until it's an issue.
#static func get_active_combat_hook_listeners(combat_state: CombatState) -> Array[AbstractModel]:
	#return []

## See [method AbstractModel.before_attack].
static func before_attack(combat_state: CombatState, attack: AttackCommand) -> void:
	for model: AbstractModel in combat_state.get_hook_listeners():
		await model.before_attack(attack)

## See [method AbstractModel.after_attack].
static func after_attack(combat_state: CombatState, attack: AttackCommand) -> void:
	for model: AbstractModel in combat_state.get_hook_listeners():
		await model.after_attack(attack)

## See [method AbstractModel.after_card_drawn].
static func after_card_drawn(combatState: CombatState, card) -> void:
	for model: AbstractModel in combatState:
		await model.after_card_drawn(card)

## See [method AbstractModel.after_card_discarded].
static func after_card_discarded(combat_state: CombatState, card: CardModel) -> void:
	for model: AbstractModel in combat_state.get_hook_listeners():
		await model.after_card_discarded(card)

## See [method AbstractModel.after_card_changes_piles].
static func after_card_changes_piles(card: CardModel, old_pile: CardPile) -> void:
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

## Runs before a card is played. [br][br]
## Combat only.
static func before_card_played(combat_state: CombatState, card_play: CardPlay) -> void:
	for listener: AbstractModel in combat_state.get_hook_listeners():
		await listener.before_card_played(card_play)

## Runs after a card is played. [br][br]
## Combat only.
static func after_card_played(combat_state: CombatState, card_play: CardPlay) -> void:
	for listener: AbstractModel in combat_state.get_hook_listeners():
		await listener.after_card_played(card_play)

## Runs before a card exits play. [br][br]
## NOTE: This will run even if the card is instant, though it should execute immediately. [br][br]
## Combat only.
static func before_card_exited_play(combat_state: CombatState, card_play: CardPlay) -> void:
	for listener: AbstractModel in combat_state.get_hook_listeners():
		await listener.before_card_exited_play(card_play)

## Runs after a card exits play. [br][br]
## NOTE: This will run even if the card is instant, though it should execute immediately. [br][br]
## Combat only.
static func after_card_exited_play(combat_state: CombatState, card_play: CardPlay) -> void:
	for listener: AbstractModel in combat_state.get_hook_listeners():
		await listener.after_card_exited_play(card_play)

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

## Runs after damage is taken by a creature (regardless of actual damage). [br][br]
## Different from [method after_damage_given] since it will NOT run if the creature dies. For example, this can be to avoid updating statuses. Also semantics.
static func after_damage_taken(run_state: RunState, combat_state: CombatState, target: Creature, damage_result: DamageResult) -> void:
	for listener: AbstractModel in run_state.get_hook_listeners(combat_state):
		listener.after_damage_taken(target, damage_result)

# WARNING: UNUSED
## Runs before a creature dies.
static func before_death() -> void:
	push_error("not implemented")

# WARNING: UNUSED
## Runs after a creature dies.
static func after_death() -> void:
	push_error("not implemented")

## Runs after a shield is destroyed (has current_shield depleted)
## Combat only.
static func after_shield_destroyed(combat_state: CombatState, shield: Shield, dealer: Creature) -> void:
	for listener: AbstractModel in combat_state.get_hook_listeners():
		listener.after_shield_destroyed(shield, dealer)

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

static func modify_draw_time(combat_state: CombatState, player: Player, amount: float) -> float:
	var draw_time: float = amount
	
	var listeners: Array[AbstractModel] = combat_state.get_hook_listeners()
	for model: AbstractModel in listeners:
		draw_time += model.modify_draw_time_additive(player, draw_time)
	for model: AbstractModel in listeners:
		draw_time *= model.modify_draw_time_multiplicative(player, draw_time)
	
	return draw_time


static func modify_draw_time_delta(delta: float) -> float:
	return delta

# WARNING: UNUSED, unimplemented
static func modify_move_time(move_time: float) -> float:
	return move_time

# WARNING: UNUSED, unimplemented
static func modify_move_time_delta(delta: float) -> float:
	return delta

## modify the amount that will be dealt. Additive effects are applied first, followed by multiplicative effects. [br][br]
## See [method AbstractModel.modify_damage_additive] and [method AbstractModel.modify_damage_multiplicative]. [br][br]
## NOTE: this function, and most modify functions, use floats instead of ints for calculations. The value will always be converted to the correct type when used.
## This note is not included on other modify functions b/c I'm lazy, but it applies to them as well.
static func modify_damage(run_state: RunState, combat_state: CombatState, target: Creature, dealer: Creature, amount: float, card_source: CardModel) -> float:
	var damage: float = amount
	
	var listeners: Array[AbstractModel] = run_state.get_hook_listeners(combat_state)
	for model: AbstractModel in listeners:
		damage += model.modify_damage_additive(target, dealer, damage, card_source)
	for model: AbstractModel in  listeners:
		damage *= model.modify_damage_multiplicative(target, dealer, damage, card_source)
	
	return damage

# NOTE: Theoretically more efficient to merge with modify_shield_amount_internal. Could change to a hook that's just "modify_shield_additive". On the other hand, doing it memberwise helps with previewing values.
## Modify a shield. Additive effects are applied first, followed by multiplicative effects. [br][br]
## See [method AbstractModel.modify_shield_additive] and [method AbstractModel.modify_shield_multiplicative].
static func modify_shield(combat_state: CombatState, creature: Creature, shield: Shield, card_source: CardModel) -> Shield:
	shield.current_shield = int(modify_shield_amount_internal(combat_state, creature, shield.current_shield, card_source))
	return shield

## Use [method modify_shield] for calculations (which can change other aspects of the shield). This is a helper method to organize hooks.
static func modify_shield_amount_internal(combat_state: CombatState, creature: Creature, amount: float, card_source: CardModel) -> float:
	var shield_amount: float = amount
	
	var listeners: Array[AbstractModel] = combat_state.get_hook_listeners()
	for model: AbstractModel in listeners:
		shield_amount += model.modify_shield_additive(creature, shield_amount, card_source)
	for model: AbstractModel in listeners:
		shield_amount *= model.modify_shield_multiplicative(creature, shield_amount, card_source)
		
	return shield_amount

## Modify the max amount of damage that can be dealt. Useful implementing effects like invulnerability. Another reason I'm choosing this over just
## modify damage (even for invulnerability) is so it doesn't mess with the current preview logic (i.e. you should still see how much damage a card
## WOULD deal, but that's a bit to copy STS2.
static func modify_damage_cap(combat_state: CombatState, target: Creature, dealer: Creature, card_source: CardModel) -> float:
	var damage_cap: float = INF
	for listener: AbstractModel in combat_state.get_hook_listeners():
		var alternate_cap: float = listener.modify_damage_cap(target, dealer, card_source)
		if alternate_cap < damage_cap:
			damage_cap = alternate_cap
	return damage_cap

## Modify the play duration of a card.
static func modify_card_duration(combat_state: CombatState, card: CardModel, amount: float) -> float:
	var card_duration: float = amount
	
	var listeners: Array[AbstractModel] = combat_state.get_hook_listeners()
	for model: AbstractModel in listeners:
		card_duration += model.modify_card_duration_additive(card, card_duration)
	for model: AbstractModel in listeners:
		card_duration *= model.modify_card_duration_multiplicative(card, card_duration)
	
	return card_duration
