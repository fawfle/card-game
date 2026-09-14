class_name UpgradeRoom extends AbstractRoom
## A room where the player can upgrade cards
##
## TODO: possibly give more options when creating an upgrade room. Currently, they manage everything (like what upgrades are given) by themselves.

var run_state: RunState

var upgrade: UpgradeModel

func _init() -> void:
	upgrade = RunManager.instance.get_random_upgrade()

func enter(state: RunState) -> void:
	run_state = state
	var upgrade_room_node: UpgradeRoomNode = UpgradeRoomNode.create(self)
	RunNode.instance.set_current_room(upgrade_room_node)

func exit() -> void:
	RunNode.instance.clear_current_room()
