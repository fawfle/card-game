class_name PathosCounter extends Control

var _player: Player

@onready var count_label: Label = %CountLabel
@onready var texture_progress_bar: TextureProgressBar = $Panel/TextureProgressBar

func initialize(player: Player) -> void:
	_player = player
	player.player_combat_state.on_pathos_changed.connect(_on_pathos_changed)
	player.player_combat_state.on_pathos_gain_timer_changed.connect(_on_pathos_gain_timer_changed)
	update_visuals()

func update_visuals() -> void:
	var current_pathos = _player.player_combat_state.pathos
	var max_pathos = _player.player_combat_state.get_max_pathos()
	count_label.text = "%d/%d" % [current_pathos, max_pathos]
	
	var pathos_time: float = _player.player_combat_state.get_pathos_time()
	var fill_amount: float = _player.player_combat_state.pathos_gain_timer
	if current_pathos == max_pathos: fill_amount = pathos_time
	texture_progress_bar.max_value = pathos_time
	texture_progress_bar.value = fill_amount

func _on_pathos_changed(_old_pathos: int, _new_pathos: int) -> void:
	update_visuals()

func _on_pathos_gain_timer_changed() -> void:
	update_visuals()
