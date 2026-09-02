class_name CardNode extends Control
## Has [method create].

const SIZE: Vector2 = Vector2(160, 240)

## Legally mouse_down for gamefeel.
signal pressed(card: CardNode)

const SCENE: PackedScene = preload("res://scenes/cards/card.tscn")

var model: CardModel = null

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

static func create(card_model: CardModel) -> CardNode:
	var card: CardNode = SCENE.instantiate()
	card.model = card_model
	return card

func _ready() -> void:
	button.pressed.connect(_on_pressed)
	update_visuals()

func _process(delta: float) -> void:
	update_card_play_visuals()

func update_visuals() -> void:
	if model == null: push_error("Cannot update visuals without a model. Make sure to use create().")
	title_label.text = model.get_id_name()
	description.text = model.get_description()
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

func update_card_play_visuals():
	if model.active_card_play:
		play_timer_progress_bar.show()
		play_timer_progress_bar.max_value = model.active_card_play.play_duration
		play_timer_progress_bar.value = model.active_card_play.play_time_left
	else:
		play_timer_progress_bar.hide()

func _on_pressed():
	pressed.emit(self)
