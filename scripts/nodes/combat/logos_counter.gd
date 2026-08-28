class_name LogosCounter extends Control

var _player: Player

@onready var count_label: Label = %CountLabel

func initialize(player: Player) -> void:
	_player = player
	player.player_combat_state.on_logos_changed.connect(_on_logos_changed)
	update_label()

func update_label() -> void:
	count_label.text = "%d/%d" % [_player.player_combat_state.logos, _player.player_combat_state.get_max_logos()]

func _on_logos_changed(_old_logos: int, _new_logos: int) -> void:
	update_label()
