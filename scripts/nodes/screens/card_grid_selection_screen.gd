class_name CardGridSelectionScreen extends Control
## A screen to select multiple cards from a grid
##
## NOTE: if more specific functionality is needed, create subclasses

## Emitted when the cards are selected and confirmed
signal cards_selected(cards: Array[CardModel])

const SCENE: PackedScene = preload("res://scenes/screens/card_grid_selection_screen.tscn")

var _cards: Array[CardModel]

var selected_card_nodes: Array[CardNode] = []
var selected_cards: Array[CardModel]:
	get(): return selected_card_nodes.map(func(card_node: CardNode): return card_node.model)

var _max_select_count: int
## TODO: Currently hardcoded, make work/an option
var _can_select_less: bool = false

## TODO: make an option to cancel (if cancellable)

@onready var prompt: Label = %Prompt
@onready var card_grid: CardGrid = %CardGrid
@onready var confirm_button: Button = %ConfirmButton

static func create(list: Array[CardModel], max_select_count: int) -> CardGridSelectionScreen:
	var screen: CardGridSelectionScreen = SCENE.instantiate()
	screen._cards = list
	screen._max_select_count = max_select_count
	return screen

func _ready() -> void:
	card_grid.set_cards(_cards)
	card_grid.card_pressed.connect(_on_card_pressed)
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	
	prompt.text = "SELECT 1 CARD" if _max_select_count == 1 else "SELECT %d CARDS" % _max_select_count 

func is_selection_valid() -> bool:
	return (_can_select_less and selected_cards.size() <= _max_select_count) or (not _can_select_less and selected_cards.size() == _max_select_count)

func _on_card_pressed(card_node: CardNode) -> void:
	if card_node in selected_card_nodes:
		selected_card_nodes.erase(card_node)
		card_node.scale = 1.0 * Vector2.ONE
	else:
		selected_card_nodes.append(card_node)
		card_node.scale = 1.2 * Vector2.ONE
		while selected_card_nodes.size() > _max_select_count:
			var removed_card: CardNode = selected_card_nodes.pop_front()
			removed_card.scale = 1.0 * Vector2.ONE

func _on_confirm_button_pressed() -> void:
	if is_selection_valid():
		cards_selected.emit(selected_cards)
