class_name ConcealedEffect extends EffectModel
## Can only deal damage every other hit

var actively_concealed: bool = true

func get_icon() -> Texture2D: return preload("res://assets/icons/hidden.png")

func get_title() -> String: return "Concealed"

func get_description() -> String:
	if actively_concealed: return "Only takes damage every other hit. Currently invulnerable."
	else: return "Only takes damage every other hit. Currently vulnerable."

func is_inactive() -> bool: return not actively_concealed

func after_damage_taken(target: Creature, _damage_result: DamageResult) -> void:
	if target == owner:
		if actively_concealed: EffectCommand.decrement_amount(self)
		actively_concealed = not actively_concealed

func modify_damage_cap(target: Creature, _dealer: Creature, _card_source: CardModel) -> float:
	if target == owner and actively_concealed:
		return 0.0
	return INF
