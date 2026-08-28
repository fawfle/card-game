extends Node

## signal to try to play a card
@warning_ignore("unused_signal")
signal try_play_card()
## signal that a card was successfully played
@warning_ignore("unused_signal")
signal card_played(card: Card)
## Signal that a card has exited play
@warning_ignore("unused_signal")
signal card_exited(card: Card)

## Signal used by enemies to attack
@warning_ignore("unused_signal")
signal enemy_attack()

## Signal for when an enemy attack has hit (after clashes etc.)
@warning_ignore("unused_signal")
signal enemy_attack_hit()

signal round_start()

var card_hand: CardHandDisplay = null
var card_manager: CardManager = null

var deck_data: DeckData = preload("res://resources/decks/test_deck.tres")

var player: PlayerDepreciated = null
var current_enemy: EnemyDepreciated = null

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	round_start.emit()
