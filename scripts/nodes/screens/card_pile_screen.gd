class_name CardPileScreen extends Control

const SCENE: PackedScene = preload("res://scenes/screens/card_pile_screen.tscn")

var _pile: CardPile = null

@onready var card_grid: CardGrid = $CardGrid
@onready var back_button: Button = $BackButton

static func create(pile: CardPile) -> CardPileScreen:
	var screen: CardPileScreen = SCENE.instantiate()
	screen._pile = pile
	return screen

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	
	_pile.contents_changed.connect(_on_pile_contents_changed)
	_on_pile_contents_changed()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_back_pressed()

func _on_pile_contents_changed() -> void:
	card_grid.set_cards(_pile.cards)

func _on_back_pressed() -> void:
	if RunNode.instance.global_ui.overlay_screen.current_scene != self: return
	RunNode.instance.global_ui.close_overlay_screen()
