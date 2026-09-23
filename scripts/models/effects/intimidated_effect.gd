class_name IntimidatedEffect extends EffectModel
## Decreases the player's draw rate.

const ICON: Texture2D = preload("res://assets/icons/terror.png")

func get_title() -> String: return "Intimidated"

func get_description() -> String:
	return "Increases draw time by %d%%" % int(get_modifier() * 100)

static func get_generic_description() -> String:
	return "Increases draw time."

func get_icon() -> Texture2D: return ICON

func modify_draw_time_multiplicative(player: Player, _draw_time: float) -> float:
	if (owner.player and owner.player == player):
		return 1 + get_modifier()
	return 1.0
func get_modifier() -> float:
	return amount * 0.1
