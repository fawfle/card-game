class_name Player
## The highest level representation of a player.
##
## To initialize a player for a new run, see [method create_for_new_run]. For combat specifically, see [PlayerCombatState].

var run_state: RunState = null:
	set(value):
		if run_state != null: push_error("run_state of player already set.")
		run_state = value

var character: CharacterModel = null

## The creature associated with the player.
var creature: Creature = null

var player_combat_state: PlayerCombatState = null

var deck: CardPile = CardPile.new(Constants.PileType.DECK)

func get_piles() -> Array[CardPile]:
	var piles: Array[CardPile] = [deck]
	if player_combat_state != null:
		piles.append_array(player_combat_state.all_piles)
	return piles

const hand_limit: int = 10

var max_pathos: int
var max_logos: int

## How long it takes to generate 1 pathos.
var pathos_time: float

## How many cards the player starts combat with.
var initial_card_count: int
## How long it takes to draw a card.
var draw_time: float

## Avoid using directly. Different initialization methods are used for future flexibility, specifically with saving and loading.
func _init(character_model: CharacterModel) -> void:
	character = character_model
	creature = Creature.from_player(self)
	creature.side = Constants.CombatSide.ALLY
	max_pathos = character_model.get_starting_max_pathos()
	max_logos = character_model.get_starting_max_logos()
	initial_card_count = character.get_starting_initial_card_count()
	draw_time = character.get_starting_draw_time()
	pathos_time = character.get_starting_pathos_time()

## Perform initialization for a new player
static func create_for_new_run(character_model: CharacterModel) -> Player:
	var player: Player = Player.new(character_model)
	player.populate_starting_deck()
	return player

func reset_combat_state() -> void:
	player_combat_state = PlayerCombatState.new(self)

## Perform necessary setup for a new PlayerCombatState. For example, adds cards from the deck into the draw pile.
func populate_combat_state(_state: CombatState) -> void:
	for card: CardModel in deck.cards:
		var combat_card: CardModel = card.clone_mutable()
		combat_card.deck_version = card
		player_combat_state.draw_pile.add_internal(combat_card)
	player_combat_state.draw_pile.shuffle_internal()
	
	player_combat_state.pathos = player_combat_state.get_max_pathos()

## Populate the deck the starting cards of the associated Character. Should be called when creating a player for a new run.
func populate_starting_deck() -> void:
	var starting_cards: Array[CardModel] = []
	for card: CardModel in character.get_starting_deck():
		starting_cards.append(card.clone_mutable_from_base())
	populate_deck(starting_cards)

## Populate the deck with a list of cards.
func populate_deck(cards: Array[CardModel]) -> void:
	if not deck.cards.is_empty(): push_error("deck is not empty.")
	for card: CardModel in cards:
		if not card.is_mutable: push_error("deck should not be populated with base cards.")
		register_card(card)
		deck.add_internal(card)

func register_card(card: CardModel) -> void:
	if card.owner and card.owner != self: push_error("trying to register a card to a player that already has an owner")
	card.owner = self

## Helper function to do null checking and avoid explicitly accessing player_combat_state. Could be dumb and have overhead.
func get_pile(type: Constants.PileType) -> CardPile:
	match(type):
		Constants.PileType.NONE: return null
		Constants.PileType.DECK: return deck
	
	if not player_combat_state: return null
	
	match(type):
		Constants.PileType.DRAW: return player_combat_state.draw_pile
		Constants.PileType.HAND: return player_combat_state.hand
		Constants.PileType.DISCARD: return player_combat_state.discard_pile
		Constants.PileType.PLAY: return player_combat_state.play_pile
	
	return null
