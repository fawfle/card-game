class_name StrongUpgrade extends UpgradeModel
## Additive damage

var _damage_additive: int = 2

func get_description() -> String: return "Increases damage by %s." % _damage_additive

func upgrade_damage_additive(damage_amount: float) -> float:
	return _damage_additive
