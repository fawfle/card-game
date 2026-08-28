class_name DeckData extends Resource
## Data resource for decks. Decks are collections of cards

## Should not be modified directly. Use [method add_card] instead to ensure resources are copied correctly.
@export var cards: Array[CardData]

## Should be used to add cards.
func add_card(card: CardData):
	cards.append(card.duplicate_deep())
