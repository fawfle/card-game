class_name DeckButton extends Control
## Button to let player view their deck.
##
## For some minor future reasons (such as it being global and having display priority), I think it makes sense to have it be a separate script for now.

var _player: Player = null

@onready var button: TextureButton = %Button

func _ready() -> void:
	button.pressed.connect(_on_pressed)

func initialize(player: Player) -> void:
	_player = player

func _on_pressed() -> void:
	RunNode.instance.global_ui.set_overlay_screen(CardPileScreen.create(_player.deck))
