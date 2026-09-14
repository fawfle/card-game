class_name CardGridSelectionScreen extends Control
## A screen to select multiple cards from a grid
##
## NOTE: if more specific functionality is needed, create subclasses

## Emitted when the cards are selected and confirmed
signal cards_selected(cards: Array[CardModel])

const SCENE: PackedScene = preload("res://scenes/screens/card_grid_selection_screen.tscn")

var _cards: Array[CardModel]

var selected_cards: Array[CardModel] = []

var _max_select_count: int
## TODO: Currently hardcoded, make work/an option
var _can_select_less: bool = false

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
	var card: CardModel = card_node.model
	if card in selected_cards:
		selected_cards.erase(card)
		card_node.scale = 1.0 * Vector2.ONE
	elif selected_cards.size() < _max_select_count:
		selected_cards.append(card)
		card_node.scale = 1.2 * Vector2.ONE

func _on_confirm_button_pressed() -> void:
	if is_selection_valid():
		cards_selected.emit(selected_cards)
