class_name UpgradeSlotNode extends Control

const SCENE: PackedScene = preload("res://scenes/cards/upgrade_slot.tscn")

var _upgrade: UpgradeModel = null

@onready var filled_rect: ColorRect = %FilledRect

static func create(upgrade: UpgradeModel) -> UpgradeSlotNode:
	var slot: UpgradeSlotNode = SCENE.instantiate()
	slot._upgrade = upgrade
	return slot

func _ready() -> void:
	if _upgrade:
		filled_rect.visible = true
		filled_rect.color = _upgrade.get_color()
