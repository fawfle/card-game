class_name GenericUpgradePool extends UpgradePoolModel

func _generate_all_upgrades() -> Array[UpgradeModel]:
	return [
		(ModelDb.upgrade(StrongUpgrade).clone_mutable_from_base() as StrongUpgrade).set_amounts(2),
		(ModelDb.upgrade(SturdyUpgrade).clone_mutable_from_base() as SturdyUpgrade).set_amounts(2),
		(ModelDb.upgrade(DurationUpgrade).clone_mutable_from_base() as DurationUpgrade).set_amounts(2),
		(ModelDb.upgrade(DrawAndDurationUpgrade).clone_mutable_from_base() as DrawAndDurationUpgrade).set_amounts(1, -2),
	]
