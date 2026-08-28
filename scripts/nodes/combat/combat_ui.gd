class_name CombatUi extends Control
## Keeps track of combat UI and performs initialization.

@onready var draw_pile_button: CombatCardPileButton = %DrawPileButton
@onready var discard_pile_button: CombatCardPileButton = %DiscardPileButton

@onready var player_hand: PlayerHandNode = %PlayerHand
@onready var pathos_counter: PathosCounter = %PathosCounter
@onready var logos_counter: LogosCounter = %LogosCounter

@onready var in_play_cards_container: HBoxContainer = %InPlayCardsContainer
@onready var draw_progress_bar: TextureProgressBar = $DrawProgressBar

## Activate and initialize combat UI. Make sure to call when combat starts.
func activate(combat_state: CombatState):
	var player: Player = RunManager.instance.run_state.player
	draw_pile_button.initialize(player)
	discard_pile_button.initialize(player)
	pathos_counter.initialize(player)
	logos_counter.initialize(player)

func _process(delta: float) -> void:
	draw_progress_bar.max_value = RunManager.instance.run_state.player.player_combat_state.get_draw_time()
	draw_progress_bar.value = RunManager.instance.run_state.player.player_combat_state.time_since_last_draw
