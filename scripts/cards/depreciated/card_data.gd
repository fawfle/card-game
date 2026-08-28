class_name CardData extends Resource
## Data resource for cards

const DESCRIPTION_DELIMITER_OPEN := &"{"
const DESCRIPTION_DELIMITER_CLOSE := &"}"
const PAYLOAD_DELIMITER := &":"

enum Priority {
	NONE = 0,
	DEFENSIVE = 1,
	COUNTER = 2,
}

@export var icon: Texture2D = null

## Description text. Properties from effects can be specified using "{[i]effect_index[/i]:[i]property[/i]}". For example, "[code]Deal {0:damage} damage[/code]"
@export_multiline() var description: String = ""

## How long the card will be in play for.
@export var in_play_duration: float = 0.0

## If the card can clash. A clash occurs when damage (or some other effect) would be recieved. EX: Upon taking damage, a Shield card in play would clash, reducing the damage taken.
@export var clashes: bool = false

## A priority index for taking effect. Enum for more readable index value. EX: a Counter card would take effect before a Defensive card, regardless of time in play.
@export var priority: Priority = Priority.NONE

@export var card_effects: Array[CardEffect] = []
## TODO: modifiers on cards like 2x damage or smthing
# @export var card_modifiers: Array[CardModifier] = []

func reset_effects():
	for effect: CardEffect in card_effects:
		effect.reset()

func on_play_start(card: Card):
	for effect: CardEffect in card_effects:
		effect.on_play_start(card)

func on_play_end(card: Card):
	for effect: CardEffect in card_effects:
		effect.on_play_end(card)

func on_clash(card: Card, attack: Attack) -> Attack:
	for effect: CardEffect in card_effects:
		effect.on_clash(card, attack)
	
	return attack

func on_destroy(card: Card):
	for effect: CardEffect in card_effects:
		effect.on_destroy(card)

func in_play_process(card: Card, delta: float):
	for effect: CardEffect in card_effects:
		effect.in_play_process(card, delta)

func parse_description(card) -> String:
	var result: String = ""
	var current_index: int = 0
	while description.find(DESCRIPTION_DELIMITER_OPEN, current_index) != -1:
		var start_index: int = description.find(DESCRIPTION_DELIMITER_OPEN, current_index) + 1
		result += description.substr(current_index, start_index - current_index - 1)
		
		var end_index: int = description.find(DESCRIPTION_DELIMITER_CLOSE, start_index)
		var payload: String = description.substr(start_index, end_index - start_index)
		var payloads := payload.split(PAYLOAD_DELIMITER)
		
		result += str(card_effects[payloads[0].to_int()].get(payloads[1]))
		current_index = end_index + 1
	
	result += description.substr(current_index)
	
	return result
