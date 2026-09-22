class_name AttackIntent extends AbstractIntent
## Represents that an enemy will attack. For visuals.

const ICON: Texture2D = preload("res://assets/icons/weapon_icon.webp")

func get_title() -> String: return "Attack"

func get_description(_owner: Creature, _targets: Array[Creature]) -> String: return "Intends to attack."

func get_icon() -> Texture2D: return ICON

var _damage: int = 0
var _hit_count: int = 1

func get_label(owner: Creature, targets: Array[Creature]) -> String:
	var damage: float = _damage if targets.size() == 0 else get_damage(owner, targets.get(0))
	if _hit_count == 1: return "%d" % damage
	else: return "%dx%d" % [damage, _hit_count]

## base damage to deal, base number of times to hit
func _init(damage: int) -> void:
	_damage = damage

func with_hit_count(count: int) -> AttackIntent:
	_hit_count = count
	return self

## WARNING: Currently unused (i.e. stuff just returns damage raw).
func get_damage(owner: Creature, target: Creature) -> int:
	if not owner or not target: return _damage
	return max(0, int(Hook.modify_damage(RunManager.instance.run_state, owner.combat_state, target, owner, _damage, null)))
