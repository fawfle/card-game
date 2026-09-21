class_name IrritableEffect extends EffectModel

func get_title() -> String: return "Irritable"

func get_icon() -> Texture2D: return preload("res://assets/icons/angry_eyes.png")

func get_description() -> String: return "The next %d times this creature is hit, immediately perform a move" % amount

func after_damage_taken(target: Creature, _damage_result: DamageResult) -> void:
	if target == owner and owner.enemy:
		owner.enemy.perform_move()
		decrement_amount()
