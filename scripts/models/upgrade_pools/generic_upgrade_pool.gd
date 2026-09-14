class_name GenericUpgradePool extends UpgradePoolModel

func _generate_all_upgrades() -> Array[UpgradeModel]:
	return [
		ModelDb.upgrade(StrongUpgrade),
		ModelDb.upgrade(SturdyUpgrade)
	]
