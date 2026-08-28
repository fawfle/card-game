class_name PlayCardArea extends TextureButton

func _ready() -> void:
	pressed.connect(_try_play_card)

func _try_play_card():
	GameManager.try_play_card.emit()
