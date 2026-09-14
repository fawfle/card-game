class_name SturdyUpgrade extends UpgradeModel
## Additive shield

var _shield_additive: int = 2

func get_description() -> String: return "Increases shield by %s." % _shield_additive

func upgrade_shield_additive(shield_amount: float) -> float:
	return _shield_additive
