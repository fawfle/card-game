class_name CardManager extends Node
## class for managing cards. Main function is to manage them while they're in play like handling clashes

const CARD_SCENE = preload("res://scenes/cards/old_card.tscn")

@export var in_play_cards_parent: Node = null

var deck: Deck = null

# TODO: Should get sorted by priority
## Array of cards that are currently in play
var in_play_cards: Array[Card] = []

func _ready() -> void:
	GameManager.card_manager = self
	GameManager.card_played.connect(_on_card_played)
	GameManager.card_exited.connect(_on_card_exited)
	GameManager.round_start.connect(_on_round_start)
	GameManager.enemy_attack.connect(_on_enemy_attack)
	
	deck = Deck.new(GameManager.deck_data)
	deck.reset_deck()

func _on_round_start() -> void:
	for i in min(len(deck.deck_data.cards), 10):
		draw_card_into_hand()

func _on_enemy_attack(attack: Attack) -> void:
	for card: Card in in_play_cards:
		if card.card_data.clashes: card.clash(attack)
	GameManager.enemy_attack_hit.emit(attack)

func _on_card_played(card: Card) -> void:
	in_play_cards.push_back(card)
	card.reparent(in_play_cards_parent)

func _on_card_exited(card: Card) -> void:
	in_play_cards.erase(card)
	card.queue_free()
	deck.discard_card(card.card_data)

func draw_card_into_hand() -> void:
	var card_data: CardData = deck.draw_card()
	if not card_data: return
	GameManager.card_hand.add_card(create_card_instance(card_data))

static func create_card_instance(data: CardData) -> Card:
	var card: Card = CARD_SCENE.instantiate()
	card.card_data = data
	return card
