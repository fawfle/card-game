class_name AttackIntent extends AbstractIntent
## Represents that an enemy will attack. For visuals.

const ICON: Texture2D = preload("res://assets/icons/weapon_icon.webp")

func get_title() -> String: return "Attack"

func get_icon() -> Texture2D: return ICON

var _damage: int = 0

func get_label(owner: Creature, targets: Array[Creature]) -> String: return str(get_damage(owner, targets.get(0)))

func _init(damage: int) -> void:
	_damage = damage

## WARNING: Currently unused (i.e. stuff just returns damage raw).
func get_damage(owner: Creature, target: Creature) -> int:
	if not owner or not target: return _damage
	return max(0, int(Hook.modify_damage(RunManager.instance.run_state, owner.combat_state, target, owner, _damage, null)))
