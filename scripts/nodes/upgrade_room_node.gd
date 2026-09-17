class_name UpgradeRoomNode extends Control
## A simple room where you can upgrade a card.
##
## TODO: add more features like rerolling, choosing between multiple upgrades, applying upgrades to multiple cards, etc.
## TODO: Preview upgrade on card

const SCENE: PackedScene = preload("res://scenes/rooms/upgrade_room.tscn")

var _upgrade_room: UpgradeRoom

var _selected_card: CardModel

var upgraded: bool = false

@onready var selected_cards_container: HBoxContainer = %SelectedCardsContainer
@onready var description: Label = %Description
@onready var select_button: Button = %SelectButton
@onready var confirm_button: Button = %ConfirmButton

@onready var proceed_button: Button = %ProceedButton

static func create(upgrade_room: UpgradeRoom) -> UpgradeRoomNode:
	var room: UpgradeRoomNode = SCENE.instantiate()
	room._upgrade_room = upgrade_room
	return room

func _ready() -> void:
	proceed_button.pressed.connect(_on_proceed_button_pressed)
	select_button.pressed.connect(_on_select_button_pressed)
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	update_visuals()

func update_visuals() -> void:
	select_button.disabled = upgraded
	confirm_button.disabled = _selected_card == null or upgraded
	
	proceed_button.text = "SKIP" if not upgraded else "PROCEED"
	
	description.text = _upgrade_room.upgrade.get_description()
	
	for child: Node in selected_cards_container.get_children():
		child.queue_free()
	
	if _selected_card:
		selected_cards_container.add_child(CardNode.create(_selected_card))

func _on_select_button_pressed() -> void:
	if upgraded: return
	_selected_card = await CardSelectCommand.select_card_for_upgrade(_upgrade_room.run_state.player)
	update_visuals()

func _on_confirm_button_pressed() -> void:
	if upgraded: return
	upgraded = true
	CardCommand.upgrade(_selected_card, _upgrade_room.upgrade)
	update_visuals()

func _on_proceed_button_pressed() -> void:
	RunManager.instance.proceed_from_room()
