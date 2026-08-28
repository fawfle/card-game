class_name CardHandDisplay extends Control

@export var radius: float = 1200
@export var angle_spacing: float = 0.06

@export var enter_animation_speed: float = 0.4
@export var position_speed: float = 200
@export var add_card_delay: float = 0.2

@onready var play_timer: Timer = $PlayTimer

## A list of cards in the hand. Cards in hand are literal children of this node.
var cards: Array[Card] = []

## Keeps track of cards being added.
var add_cards_queue: Array[Card] = []
## Keeps track of cards visible in hand.
var visible_cards: Array[Card] = []

var hovered_card: Card = null
var selected_card: Card = null

func _ready() -> void:
	GameManager.card_hand = self
	GameManager.try_play_card.connect(_play_selected_card)
	child_entered_tree.connect(_on_child_entered)
	child_exiting_tree.connect(_on_child_exited)
	
	# call callback manually
	for child in get_children():
		_on_child_entered(child)

func _process(delta: float) -> void:
	_handle_cards_queue()
	
	if Input.is_action_just_pressed("back") and selected_card: _deselect_card(selected_card)
	
	_handle_card_positions(delta)

func _handle_cards_queue() -> void:
	if not play_timer.is_stopped() or add_cards_queue.is_empty(): return
	play_timer.start(add_card_delay)
	var card: Card = add_cards_queue.pop_front()
	_play_enter_animation(card)
	visible_cards.push_back(card)

func _handle_card_positions(delta: float) -> void:
	var pivot = Vector2(0, radius) + size / 2
	for i in len(visible_cards):
		var card: Card = visible_cards[i]
		var angle: float = (i + 0.5 - len(visible_cards) / 2.0) * angle_spacing
		# smoothing by position and calculating the angle after might be scuffed, but it looks pretty good so it doesn't matter.
		_move_towards_center(card, pivot - Vector2.from_angle(PI / 2 + angle) * radius, delta * position_speed)
		# set angle to match position rather than independently
		card.offset_transform_rotation = PI / 2 + pivot.angle_to_point(card.position + card.size / 2)
		
		if card == hovered_card or card == selected_card:
			card.offset_transform_rotation = 0

func _play_selected_card() -> void:
	if not selected_card: return
	selected_card.play()
	selected_card = null

func _on_hovered_card(card: Card) -> void:
	if selected_card: return
	hovered_card = card
	
	card.offset_transform_scale = Vector2.ONE * 1.5
	card.offset_transform_position = Vector2(0, -25)
	card.z_index = 1

func _on_unhovered_card(card: Card) -> void:
	if hovered_card == card: hovered_card = null
	
	if card != selected_card: _reset_card(card)

func _select_card(card: Card) -> void:
	if selected_card: _deselect_card(selected_card)
	
	selected_card = card
	card.offset_transform_scale = Vector2.ONE * 1.5
	card.offset_transform_position = Vector2(0, -25)
	card.z_index = 2

func _deselect_card(card: Card) -> void:
	if card == selected_card: selected_card = null
	_reset_card(card)

func _reset_card(card: Card) -> void:
	card.offset_transform_scale = Vector2.ONE
	card.offset_transform_position = Vector2.ZERO
	card.z_index = 0

func add_card(card: Card) -> void:
	add_child(card)
	_set_center(card, _get_card_position(card))
	add_cards_queue.push_back(card)
	card.visible = false

func add_cards(cards_to_add: Array[Card]) -> void:
	for card: Card in cards_to_add:
		add_card(card)

func _get_card_position(card: Card) -> Vector2:
	var pivot := Vector2(0, radius) + size / 2
	var i: int = cards.find(card)
	var angle: float = _get_card_angle(i)
	return pivot - Vector2.from_angle(PI / 2 + angle) * radius

func _get_card_angle(card_index: int) -> float:
	return (card_index + 0.5 - len(cards) / 2.0) * angle_spacing

func _play_enter_animation(card: Card, delay: float = 0) -> void:
	card.show()
	card.offset_transform_position = Vector2(-1000, 100)
	if delay: await get_tree().create_timer(delay).timeout
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "offset_transform_position", Vector2.ZERO, enter_animation_speed)
	
	await tween.finished

func _on_child_entered(node: Node) -> void:
	if not node is Card: return
	var card := node as Card
	
	cards.append(card)
	card.hovered.connect(_on_hovered_card)
	card.unhovered.connect(_on_unhovered_card)
	card.selected.connect(_select_card)
	card.deselected.connect(_deselect_card)

func _on_child_exited(node: Node) -> void:
	if not node is Card: return
	var card := node as Card
	
	cards.erase(card)
	visible_cards.erase(card)
	card.hovered.disconnect(_on_hovered_card)
	card.unhovered.disconnect(_on_unhovered_card)
	card.selected.disconnect(_select_card)
	card.deselected.disconnect(_deselect_card)

## Set the center of a node to a global position
static func _set_center(node: Control, center: Vector2) -> void:
	node.position = center - node.size / 2

## Set the center of a node to a global position with a maximum movement of delta
static func _move_towards_center(node: Control, center: Vector2, delta) -> void:
	node.position = node.position.move_toward(center - node.size / 2, delta)
