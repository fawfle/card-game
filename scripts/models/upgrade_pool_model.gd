@abstract
class_name UpgradePoolModel extends AbstractModel
## A collection of upgrades.
##
## Used to organize upgrade sets (like ones that 

var all_upgrades: Array[UpgradeModel]

## Called automatically by the class. Acess with [member all_cards].
@abstract func _generate_all_upgrades() -> Array[UpgradeModel]

func _after_model_db_initialized() -> void:
	super._after_model_db_initialized()
	all_upgrades = _generate_all_upgrades()

## Get a random set of [param count] cards. (no duplicates)
func get_random_set(count: int) -> Array[UpgradeModel]:
	if count > all_upgrades.size(): push_error("cannot get a set larger than the size of all_cards")
	
	var upgrade_set: Array[UpgradeModel] = []
	
	while upgrade_set.size() < count:
		var upgrade: UpgradeModel = all_upgrades.pick_random()
		if not upgrade_set.has(upgrade): upgrade_set.append(upgrade)
	
	return upgrade_set

func get_random_upgrade() -> UpgradeModel:
	return all_upgrades.pick_random()
