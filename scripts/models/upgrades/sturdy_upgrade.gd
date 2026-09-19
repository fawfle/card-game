class_name SturdyUpgrade extends UpgradeModel
## Additive shield

var _shield_additive: int = 0

func get_description() -> String: return "Increases shield by %s." % _shield_additive

func set_amounts(shield_additive: int) -> SturdyUpgrade:
	_shield_additive = shield_additive
	return self

func upgrade_shield_additive(shield_amount: float) -> float:
	return _shield_additive
