class_name Deck extends Node
## Manages an actual deck instance

@export var deck_data: DeckData = null

## An list of cards ordered in draw order. Back is draw.
var draw_pile: Array[CardData] = []
## A list of cards in the discard pile
var discard_pile: Array[CardData] = []

func _init(deck_data_: DeckData) -> void:
	deck_data = copy_deck_data(deck_data_)

func reset_deck() -> void:
	draw_pile = deck_data.cards
	draw_pile.shuffle()
	discard_pile.clear()

## Draw a random card from the deck. Returns [code]null[/code] if empty.
func draw_card() -> CardData:
	if draw_pile.is_empty():
		reshuffle_discard_pile()
		if draw_pile.is_empty(): return null
	
	var card_data: CardData = draw_pile.pop_back()
	card_data.reset_effects()
	return card_data

## Shuffles all cards from discard pile into the draw pile. The order of all cards (including those already in the draw pile) is randomized.
func reshuffle_discard_pile() -> void:
	draw_pile.append_array(discard_pile)
	draw_pile.shuffle()
	discard_pile.clear()

## Add a card to the discard pile. NEEDS TO BE CALLED EXTERNALLY.
func discard_card(card: CardData) -> void:
	discard_pile.push_back(card)
	card.reset_effects()

## A helper function to deep copy a deck and ensure it can be safely modified.
static func copy_deck_data(deck_to_copy: DeckData) -> DeckData:
	var deck: DeckData = DeckData.new()
	for card: CardData in deck_to_copy.cards:
		deck.add_card(card)
	return deck
