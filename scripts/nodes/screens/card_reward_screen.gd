class_name CardRewardScreen extends Control
## A screen for giving the player a card reward.

const SCENE: PackedScene = preload("res://scenes/screens/card_reward_screen.tscn")

var _cards: Array[CardModel]

@onready var card_container: HBoxContainer = %CardContainer
@onready var skip_button: Button = %SkipButton

# TODO: add multi select (or make some general card selection node)

static func create(cards: Array[CardModel]) -> CardRewardScreen:
	var screen: CardRewardScreen = SCENE.instantiate()
	screen._cards = cards
	return screen

func _ready() -> void:
	skip_button.pressed.connect(_on_skip_button_pressed)
	
	for card: CardModel in _cards:
		var card_node: CardNode = CardNode.create(card)
		card_node.pressed.connect(_on_card_pressed)
		card_container.add_child(card_node)

func _on_card_pressed(card_node: CardNode) -> void:
	var card_to_add: CardModel = card_node.model.clone_mutable()
	RunManager.instance.run_state.player.register_card(card_to_add)
	CardPileCommand.add_to_pile(RunManager.instance.run_state.player.deck, card_to_add)
	RunNode.instance.global_ui.close_overlay_screen_if_active(self)

func _on_skip_button_pressed() -> void:
	RunNode.instance.global_ui.close_overlay_screen_if_active(self)
