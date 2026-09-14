class_name SupportEffect extends EffectModel

const ICON: Texture2D = preload("res://assets/icons/shield_icon.webp")

func get_title() -> String: return "Support"

func get_description() -> String:
	if amount < 0: return "Shields start with %d less block." % -amount
	return "Shields start with %d extra block." % amount

func get_icon() -> Texture2D: return ICON

func modify_shield_additive(creature: Creature, shield_amount: float, card_source: CardModel) -> float:
	if creature != owner:
		return 0
	
	return amount
