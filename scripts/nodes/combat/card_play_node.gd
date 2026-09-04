class_name CardPlayNode extends Control
## Manages UI and input logic for playing a card. Must be started with [method start]. Don't confuse with [CardPlay].
##
## Can be cancelled and can cancel itself. Has a [method create] method.

## Emitted when the cardplay successfully starts
signal started(node: CardPlayNode)
## Emitted when the cardplay stops for any reason
signal finished(node: CardPlayNode, success: bool)

var card_node: CardNode = null
## The index of the hand the card_node was in before the cardplay
var hand_index: int = 0

## TODO: the default for now. Later, allow tap toggle selection
var dragging: bool = false

var _cancelled: bool = false

static func create(card: CardNode) -> CardPlayNode:
	var card_play: CardPlayNode = CardPlayNode.new()
	card_play.card_node = card
	return card_play

func start() -> void:
	if not card_node: push_error("should have card_node")
	
	if not card_node.model.can_play():
		finished.emit(self, false)
		return
	
	var cancelled: bool = await start_card_drag()
	if cancelled:
		finished.emit(self, false)
		return
	
	# Target can be null! (for cards that do generic things like draw)
	var target: Creature = card_node.model.get_target()
	
	started.emit(self)
	
	card_node.reparent(CombatRoomNode.instance.ui.in_play_cards_container)
	await CardCommand.play(card_node.model, target)
	card_node.queue_free()
	finished.emit(self, true)

func start_card_drag() -> bool:
	while (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or _cancelled:
			return true
		card_node.global_position = get_viewport().get_mouse_position()
		await get_tree().process_frame
	
	return false

func cancel() -> void:
	_cancelled = true
