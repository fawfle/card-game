class_name CardNode extends Control
## Has [method create].

const SIZE: Vector2 = Vector2(160, 240)

## Legally mouse_down for gamefeel.
signal pressed(card: CardNode)

const SCENE: PackedScene = preload("res://scenes/cards/card.tscn")

var model: CardModel = null

## The target of the CardNode. Used for previews. Logic should use the [CardModel] and [CardPlay].
var _target: Creature = null

@onready var title_label: Label = %TitleLabel
@onready var description: RichTextLabel = %Description

@onready var icon: TextureRect = %Icon
@onready var duration_label: Label = %DurationLabel
@onready var button: TextureButton = %Button
@onready var play_timer_progress_bar: TextureProgressBar = %PlayTimerProgressBar

@onready var pathos_icon: Panel = %PathosIcon
@onready var logos_icon: Panel = %LogosIcon
@onready var pathos_label: Label = %PathosLabel
@onready var logos_label: Label = %LogosLabel

@onready var upgrade_slot_container: HBoxContainer = %UpgradeSlotContainer

var _pathos_flash_tween: Tween = null
var _logos_flash_tween: Tween = null

static func create(card_model: CardModel) -> CardNode:
	var card: CardNode = SCENE.instantiate()
	card.model = card_model
	return card

func _ready() -> void:
	button.pressed.connect(_on_pressed)
	update_upgrade_slots()
	update_visuals()

func _process(delta: float) -> void:
	update_card_play_visuals()

func update_visuals() -> void:
	if model == null: push_error("Cannot update visuals without a model. Make sure to use create().")
	title_label.text = model.get_title()
	description.text = model.get_formatted_description(model.get_card_pile_type(), _target)
	duration_label.text = str(model.get_play_duration())
	if duration_label.text == "0.0": duration_label.text = "!"
	
	var pathos_cost = model.get_pathos_cost_with_modifiers()
	var logos_cost = model.get_logos_cost_with_modifiers()
	
	pathos_icon.visible = pathos_cost != 0
	pathos_label.text = str(pathos_cost)
	logos_icon.visible = logos_cost != 0
	logos_label.text = str(logos_cost)
	
	icon.texture = model.get_icon()
	
	update_card_play_visuals()

func update_upgrade_slots() -> void:
	for child: Node in upgrade_slot_container.get_children():
		child.queue_free()
	
	for i in range(model.get_upgrade_slot_count()):
		var upgrade_slot: UpgradeSlotNode = UpgradeSlotNode.create(model.upgrades.get(i) if i < model.upgrades.size() else null)
		upgrade_slot_container.add_child(upgrade_slot)

func update_card_play_visuals() -> void:
	if model.active_card_play:
		play_timer_progress_bar.show()
		play_timer_progress_bar.max_value = model.active_card_play.play_duration
		play_timer_progress_bar.value = model.active_card_play.play_time_left
	else:
		play_timer_progress_bar.hide()

func set_target(target: Creature) -> void:
	_target = target
	update_visuals()

func clear_target() -> void:
	_target = null
	update_visuals()

## Flash the pathos cost. For example, if the player doesn't have enough to afford to play the card.
func flash_pathos_cost() -> void:
	if _pathos_flash_tween: _pathos_flash_tween.kill()
	_pathos_flash_tween = create_tween()
	_pathos_flash_tween.tween_property(pathos_icon, "modulate:a", 0.6, 0.15)
	_pathos_flash_tween.tween_property(pathos_icon, "modulate:a", 1.0, 0.3)

func flash_logos_cost() -> void:
	if _logos_flash_tween: _logos_flash_tween.kill()
	_logos_flash_tween = create_tween()
	_logos_flash_tween.tween_property(logos_icon, "modulate:a", 0.6, 0.15)
	_logos_flash_tween.tween_property(logos_icon, "modulate:a", 1.0, 0.3)

func _on_pressed():
	pressed.emit(self)
