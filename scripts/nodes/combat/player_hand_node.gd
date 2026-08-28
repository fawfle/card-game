class_name PlayerHandNode extends Control

## The current card_play that hasn't started
var current_card_play: CardPlayNode = null

@onready var card_container: HBoxContainer = %CardContainer
@onready var selected_container: Control = $SelectedContainer

func get_selected_card() -> CardNode:
	return selected_container.get_child(0)

func add(card_node: CardNode) -> void:
	card_container.add_child(card_node)
	card_node.pressed.connect(_on_card_pressed)

func set_selected_card(card_node: CardNode) -> void:
	for child in selected_container.get_children():
		child.reparent(card_container)
	
	card_node.reparent(selected_container)
	
	if current_card_play: current_card_play.queue_free() ## could break stuff
	current_card_play = CardPlayNode.create(card_node)
	add_child(current_card_play)
	current_card_play.started.connect(_on_card_play_started)
	current_card_play.finished.connect(_on_card_play_finished)
	current_card_play.start()

func _on_card_pressed(card: CardNode) -> void:
	set_selected_card(card)

func _on_card_play_started(card_play: CardPlayNode) -> void:
	if current_card_play == card_play:
		current_card_play = null

func _on_card_play_finished(card_play: CardPlayNode, success: bool) -> void:
	if not success:
		card_play.card_node.reparent(card_container)
