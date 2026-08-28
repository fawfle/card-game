class_name CardGrid extends Control
## Displays a set of cards in a grid.

var _cards: Array[CardModel] = []

@onready var grid_container: GridContainer = %GridContainer

func set_cards(cards: Array[CardModel]) -> void:
	_cards.assign(cards)
	_cards.sort_custom(sort_cards_alphabetical)
	_update_grid()

## Update the display of the grid.
func _update_grid():
	for child: Node in grid_container.get_children():
		child.queue_free()
	
	for card: CardModel in _cards:
		var card_node: CardNode = CardNode.create(card)
		grid_container.add_child(card_node)

static func sort_cards_alphabetical(card_a: CardModel, card_b: CardModel):
	return card_a.get_id_name() > card_b.get_id_name()
