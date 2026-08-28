class_name Card extends Control

## Signals that emit self.
signal hovered(card: Card)
signal unhovered(card: Card)
signal selected(card: Card)
signal deselected(card: Card)

@onready var button: TextureButton = $TextureButton

@onready var icon: TextureRect = $Icon
@onready var description: RichTextLabel = $Description
@onready var duration_label: Label = $Time/Duration

@export var card_data: CardData = null

## If the card is in play
var in_play: bool = false
## Time left in play
var time_left: float = 0

func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.pressed.connect(_on_button_pressed)
	button.focus_exited.connect(_on_focus_exited)
	
	update_card()

func _process(delta: float) -> void:
	if in_play:
		card_data.in_play_process(self, delta)
		time_left -= delta
		duration_label.text = "%.1f" % time_left
		if time_left <= 0:
			exit_play()

func play() -> void:
	in_play = true
	card_data.on_play_start(self)
	GameManager.card_played.emit(self)
	
	time_left = card_data.in_play_duration

func clash(attack: Attack) -> Attack:
	card_data.on_clash(self, attack)
	return attack

func deal_damage(damage: float):
	GameManager.current_enemy.take_damage(damage)

func destroy() -> void:
	card_data.on_destroy(self)
	exit_play()

func exit_play() -> void:
	card_data.on_play_end(self)
	GameManager.card_exited.emit(self)

## Updates visuals on card to match data
func update_card():
	icon.texture = card_data.icon
	description.text = card_data.parse_description(self)
	duration_label.text = "!" if card_data.in_play_duration == 0 else str(card_data.in_play_duration)

func _on_mouse_entered():
	hovered.emit(self)

func _on_mouse_exited():
	unhovered.emit(self)

func _on_button_pressed():
	selected.emit(self)

func _on_focus_exited():
	deselected.emit(self)
