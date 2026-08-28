class_name AttackIntent extends AbstractIntent
## Represents that an enemy will attack. For visuals.

const ICON: Texture2D = preload("res://assets/icons/weapon_icon.webp")

func get_title() -> String: return "Attack"

func get_icon() -> Texture2D: return ICON

var _damage: int = 0

func get_label() -> String: return str(_damage)

func _init(damage: int) -> void:
	_damage = damage

func get_damage(owner: Creature, target: Creature) -> float:
	return max(0, int(Hook.modify_damage(RunManager.instance.run_state, owner.combat_state, target, owner, _damage, null)))
