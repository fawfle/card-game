class_name ShieldIntent extends AbstractIntent

const ICON: Texture2D = preload("res://assets/icons/shield_icon.webp")

func get_title() -> String: return "Shield"

func get_icon() -> Texture2D: return ICON

var _shield: int = 0

func get_label() -> String: return str(_shield)

func _init(shield: int) -> void:
	_shield = shield

## TODO: Add dynamic stuff
