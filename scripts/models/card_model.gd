@abstract
class_name CardModel extends AbstractModel

# NOTE: at least currently, signals can be executed externally by wrapper Commands.

## Logic hook. emitted when the card exits play for ANY reason.
signal exited_play()

## NOTE: Currently a bit scuffed for setting to the player, but in practice I don't think cards are created on too many ways and [i]should[/i] be made using Commands.
var owner: Player:
	get():
		assert_mutable()
		return owner
	set(value):
		assert_mutable()
		if owner and owner != value: push_error("Card " + id + " already has owner.")
		owner = value

var deck_version: CardModel:
	set(value):
		assert_mutable()
		deck_version = value

var base_instance: CardModel:
	get():
		if is_base: return self
		return base_instance
	set(value):
		assert_mutable()
		base_instance = value

## Returns the player CardPile this card is in. If it's not in a pile or the card has no owner, returns null.
func get_card_pile() -> CardPile:
	assert_mutable()
	if owner == null: return null
	var piles := owner.get_piles()
	var index := piles.find_custom(func(pile: CardPile): return pile.cards.has(self))
	if index != -1: return piles[index]
	return null

var run_state: RunState:
	get(): return owner.run_state if owner else null

var combat_state: CombatState:
	get(): return owner.creature.combat_state if owner else null

## The CardPlay that "owns" this card. null if card isn't in play.
var active_card_play: CardPlay = null

## TODO
var ToolTips

## Override to give a card a pathos cost. Get pathos cost BEFORE modifiers. See [get_pathos_cost_with_modifiers].
func get_pathos_cost() -> int: return 0
## Override to give a card a logos cost. Get logos cost BEFORE modifiers. See [get_logos_cost_with_modifiers].
func get_logos_cost() -> int: return 0

## TODO
func get_pathos_cost_with_modifiers() -> int: return get_pathos_cost()
func get_logos_cost_with_modifiers() -> int: return get_logos_cost()

func get_play_duration() -> float: return 0.0

## TODO: change to be dynamic and stuff
func get_description() -> String: return "Broken Description"

func get_icon() -> Texture2D: return null

## WARNING: Update if multiple enemies or allies are supported.
func get_target() -> Creature:
	match(get_target_type()):
		Constants.TargetType.SELF: return null if combat_state.allies.is_empty() else combat_state.allies[0]
		Constants.TargetType.ENEMY: return null if combat_state.enemies.is_empty() else combat_state.enemies[0]
	return null

@abstract func get_target_type() -> Constants.TargetType

func remove_from_current_pile() -> void:
	var pile: CardPile = get_card_pile()
	if pile == null: return
	pile.remove_internal(self)

## Get the pile type that this card will end up in after being played.
func get_play_result_pile() -> Constants.PileType:
	return Constants.PileType.DISCARD

## Runs when the card is played. Meant to be overwritten. To play a card, call [method CardCommand.play].
func on_play(card_play: CardPlay) -> void:
	pass

## Runs each frame when the card is in play. Due unpredictable behavior, avoid using this. If an effect needs to happen while the card is in play,
## consider redesigning it and having its effect happen in [method on_exit_play] or a similar method instead.
func in_play_process(delta: float) -> void:
	pass

## Runs when the card times out due to its duration reaching 0. This will not run if the card is cancelled, but some effects can timeout cards instead.
func on_timeout() -> void:
	pass

## Runs when the card is cancelled. If cancelled, this card won't timeout normally.
func on_cancelled(creature_source: Creature) -> void:
	pass

## What happens when the card exits play for any reason, either by timing out or being cancelled. [br][br]
## For more specific control, see [method on_timeout] and [method on_cancelled].
func on_exit_play() -> void:
	pass

func can_play() -> bool:
	if combat_state == null or owner.player_combat_state == null:
		return false
	return owner.player_combat_state.has_enough_resources_to_play(self)

## Spend resources to play this card. Does not check if the player actually has the required resources. Checking should be done by [method can_play].
func spend_resources() -> void:
	spend_pathos()
	spend_logos()

## TODO
func spend_pathos() -> void:
	owner.player_combat_state.lose_pathos_internal(get_pathos_cost_with_modifiers())

## TODO
func spend_logos() -> void:
	owner.player_combat_state.lose_logos_internal(get_logos_cost_with_modifiers())


func after_cloned() -> void:
	super.after_cloned()
	if base_instance == null: base_instance = ModelDb.card(get_script())
