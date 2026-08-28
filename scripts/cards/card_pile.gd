class_name CardPile
## A class for managing a pile of cards.

# NOTE: SOME UNUSED
# For updating UI.
signal card_added()
signal card_removed()
signal contents_changed()

var cards: Array[CardModel] = []

var type: Constants.PileType = Constants.PileType.NONE

func _init(type_arg: Constants.PileType) -> void:
	type = type_arg

# NOTE: STS2 has a silent flag for internal methods to not update UI. Add if needed.
## Add a card to the pile at the end. See [method CardPileCommand.add].
func add_internal(card: CardModel) -> void:
	card.assert_mutable()
	if cards.has(card): push_error("card pile already has card ", card)
	cards.push_back(card)
	
	card_added.emit()
	contents_changed.emit()

## Remove a card from the pile. See [method CardPileCommand.remove].
func remove_internal(card: CardModel) -> void:
	card.assert_mutable() ## theoretically guaranteed, but yk
	if not cards.has(card): push_error("card pile cannot remove card it does not contain: ", card)
	cards.erase(card)
	
	card_removed.emit()
	contents_changed.emit()

## Randomize the order of cards. See [method CardPileCommand.shuffle].
func shuffle_internal() -> void:
	cards.shuffle()
