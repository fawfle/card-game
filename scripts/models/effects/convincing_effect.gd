class_name ConvincingEffect extends EffectModel

const ICON: Texture2D = preload("res://assets/icons/weapon_icon.webp")

func get_title() -> String: return "Convincing"

func get_description() -> String: return "Increases all damage by %d" % amount

func get_icon() -> Texture2D: return ICON

func modify_damage_additive(_target: Creature, dealer: Creature, _damage_amount: float, _card_source: CardModel) -> float:
	if dealer != owner:
		return 0
	
	## WARNING: applies damage buff to all attacks from the dealer. Implement unaffected attacks.
	return amount
