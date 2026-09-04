class_name Creature
## A living creature with things like health.

signal on_max_hp_changed(old_max_hp: int, new_max_hp: int)
signal on_current_hp_changed(on_hp: int, new_hp: int)

## Emitted when a shield is added. NOT emitted when a shield is merged instead of added.
signal on_shield_added(shield: Shield, merged: bool)
signal on_shield_removed(shield: Shield)

signal on_effects_changed(new_effects: Array[EffectModel])

## Null if the creature does not have an associated player.
var player: Player = null
## Null if the creature does not have an associated enemy.
var enemy: EnemyModel = null

## Null for players outside of combat. Should be non null for all other creatures.
var combat_state: CombatState = null

var side: Constants.CombatSide

var shield_queue: ShieldQueue = ShieldQueue.new()

var effects: Array[EffectModel]

var max_hp: int:
	set(value):
		if value < 0: push_error("max_hp must be positive.")
		if value != max_hp:
			var old_value := max_hp
			max_hp = value
			on_max_hp_changed.emit(old_value, max_hp)

var current_hp: int:
	set(value):
		if value < 0: push_error("current_hp must be positive.")
		var old_value := current_hp
		current_hp = value
		on_current_hp_changed.emit(old_value, current_hp)

var is_alive: bool:
	get(): return current_hp > 0 

var is_dead: bool:
	get(): return current_hp <= 0

func get_creature_node() -> CreatureNode:
	return CombatRoomNode.instance.get_creature_node(self)

static func from_player(player_: Player) -> Creature:
	var creature: Creature = Creature.new()
	creature.player = player_
	creature.max_hp = player_.character.get_starting_max_hp()
	creature.current_hp = creature.max_hp
	return creature

static func from_enemy(enemy_model: EnemyModel) -> Creature:
	var creature: Creature = Creature.new()
	creature.enemy = enemy_model
	creature.max_hp = enemy_model.get_max_hp()
	creature.current_hp = creature.max_hp
	enemy_model.creature = creature
	return creature

## Called by the [CombatManager]. Use to handle real time mechanics, like shield timers.
func combat_process(delta: float) -> void:
	for shield: Shield in shield_queue.shields:
		if not shield.is_permanent and shield.card_source == null: shield.add_timeout_delta(delta)
	for effect: EffectModel in effects:
		if effect.is_temporary: effect.add_timeout_delta(delta)

## Avoid use. See [method CreatureCommand.damage_creature].
func lose_hp_internal(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)

## Applies damage to shields. This method will handle destroying shields. Returns damage left. Avoid use. See [method CreatureCommand.damage_creature]. [br]
## This method takes the dealer so the shield can have a dealer source when it gets destroyed.
func damage_shield_internal(amount: int, dealer: Creature = null) -> int:
	var amount_left: int = amount
	while(not shield_queue.shields.is_empty()):
		var shield: Shield = shield_queue.get_front()
		shield.current_shield -= amount_left
		amount_left = -shield.current_shield
		if shield.current_shield <= 0:
			shield.destroy_shield(dealer)
		
		if amount_left <= 0: return 0
	return amount_left

## Avoid use. See [method CreatureCommand.add_shield].
func add_shield_internal(shield: Shield):
	var merged: bool = shield_queue.add(shield)
	on_shield_added.emit(shield, merged)

## Avoid use. See [method CreatureCommand.remove_shield].
func remove_shield_internal(shield: Shield):
	shield_queue.remove(shield)
	on_shield_removed.emit(shield)

func apply_effect_internal(effect: EffectModel) -> void:
	if effect.owner != self: push_error("Owner of effect is not this creature. Make sure you are calling EffectModel.apply_internal.")
	effects.append(effect)
	on_effects_changed.emit(effects)

func remove_effect_internal(effect: EffectModel) -> void:
	if not effects.has(effect): push_error("trying to remove effect that is not on creature")
	effects.erase(effect)
	on_effects_changed.emit(effects)

func get_visuals() -> PackedScene:
	if enemy != null: return enemy.get_visuals()
	return null

## If the creature has an effect of the same type and same duration_type, return it. Otherwise, returns null.
func get_effect_instance(effect: EffectModel) -> EffectModel:
	for current_effect: EffectModel in effects:
		if current_effect.get_script() == effect.get_script() and current_effect.is_temporary == effect.is_temporary:
			return current_effect
	return null

func get_run_state() -> RunState:
	if player != null: return player.run_state
	if combat_state != null: return combat_state.run_state
	push_error("failed to get creature run_state")
	return null

## Reset after a combat.
func reset() -> void:
	shield_queue.clear()
	effects.clear()
