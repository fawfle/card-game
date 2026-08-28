class_name CombatCardPileButton extends Control
## Button to let player view a combat card pile (draw and discard).
##
## NOTE: For now, this script handles all combat card piles. That could change if more control is needed/I want to reduce editor stuff.

@export var _pile_type: Constants.PileType

var _pile: CardPile = null
var _player: Player = null

@onready var button: TextureButton = %Button

func _ready() -> void:
	button.pressed.connect(_on_pressed)

func initialize(player: Player) -> void:
	_player = player
	_pile = player.get_pile(_pile_type)

func _on_pressed() -> void:
	RunNode.instance.global_ui.set_overlay_screen(CardPileScreen.create(_pile))
