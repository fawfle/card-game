class_name PlayerCombatState

signal on_pathos_changed(old_pathos: int, new_pathos: int)
signal on_pathos_gain_timer_changed()
signal on_logos_changed(old_logos: int, new_logos: int)

var _player: Player

var hand: CardPile = CardPile.new(Constants.PileType.HAND)
var draw_pile: CardPile = CardPile.new(Constants.PileType.DRAW)
var discard_pile: CardPile = CardPile.new(Constants.PileType.DISCARD)
var play_pile: CardPile = CardPile.new(Constants.PileType.PLAY)

var all_piles: Array[CardPile] = [hand, draw_pile, discard_pile, play_pile]

## Avoid modifying directly. See [PlayerCommand].
var pathos: int = 0:
	set(value):
		if pathos == value: return
		var previous: int = pathos
		pathos = value
		on_pathos_changed.emit(previous, pathos)

## Avoid modifying directly. See [PlayerCommand].
var logos: int = 0:
	set(value):
		if logos == value: return
		var previous: int = logos
		logos = value
		on_logos_changed.emit(previous, logos)

func get_max_pathos() -> int:
	return int(Hook.modify_max_pathos(_player.max_pathos))

## TODO: add hook
func get_pathos_time() -> float:
	return _player.pathos_time

func get_max_logos() -> int:
	return int(Hook.modify_max_logos(_player.max_logos))

func get_initial_card_count() -> int:
	return int(Hook.modify_initial_card_count(_player.initial_card_count))

func get_draw_time() -> float:
	return Hook.modify_draw_time(_player.draw_time)

## Modify with [method add_pathos_time_delta_internal[.
var pathos_gain_timer: float = 0.0:
	set(value):
		pathos_gain_timer = value
		on_pathos_gain_timer_changed.emit()

## Modify with [method add_draw_time_delta_internal].
var time_since_last_draw: float = 0.0

func _init(player: Player) -> void:
	self._player = player

## Handle the [CombatManager]'s custom "process".
func combat_manager_process(delta: float):
	add_draw_time_delta_internal(delta)
	if time_since_last_draw >= get_draw_time():
		var cards_drawn: int = await CardPileCommand.draw(_player, 1)
		if cards_drawn >= 1:
			time_since_last_draw = 0
	add_pathos_time_delta_internal(delta)
	if pathos_gain_timer >= get_pathos_time():
		pathos += 1
		pathos_gain_timer = 0

## Avoid calling directly. See [method PlayerCommand.gain_pathos].
func gain_pathos_internal(amount: int) -> void:
	if amount < 0: push_error("amount must not be negative")
	pathos = max(0, pathos + amount)

## Avoid calling directly. See [method PlayerCommand.lose_pathos].
func lose_pathos_internal(amount: int) -> void:
	if amount < 0: push_error("amount must not be negative")
	pathos = max(0, pathos - amount)

## Avoid calling directly. See [method PlayerCommand.gain_logos].
func gain_logos_internal(amount: int) -> void:
	if amount < 0: push_error("amount must not be negative")
	logos = max(0, logos + amount)

## Avoid calling directly. See [method PlayerCommand.gain_logos].
func lose_logos_internal(amount: int) -> void:
	if amount < 0: push_error("amount must not be negative")
	logos = max(0, logos - amount)

## TODO: add hooks
func add_pathos_time_delta_internal(delta: float) -> void:
	if pathos >= get_max_pathos(): return
	pathos_gain_timer = min(pathos_gain_timer + delta, get_pathos_time())

func add_draw_time_delta_internal(delta: float) -> void:
	time_since_last_draw = min(time_since_last_draw + Hook.modify_draw_time_delta(delta), get_draw_time())

# TODO: implement unplayable reasons???
func has_enough_resources_to_play(card: CardModel) -> bool:
	var pathos_cost: int = max(0, card.get_pathos_cost_with_modifiers())
	var logos_cost: int = max(0, card.get_logos_cost_with_modifiers())
	if pathos_cost > pathos: return false
	if logos_cost > logos: return false
	return true
