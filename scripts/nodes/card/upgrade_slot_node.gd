class_name UpgradeSlotNode extends Control

const SCENE: PackedScene = preload("res://scenes/cards/upgrade_slot.tscn")

var _upgrade: UpgradeModel = null

@onready var button: TextureRect = %Button
@onready var filled_rect: ColorRect = %FilledRect

static func create(upgrade: UpgradeModel) -> UpgradeSlotNode:
	var slot: UpgradeSlotNode = SCENE.instantiate()
	slot._upgrade = upgrade
	return slot

func _ready() -> void:
	if _upgrade:
		filled_rect.visible = true
		filled_rect.color = _upgrade.get_color()
	
	button.mouse_entered.connect(_on_hovered)
	button.mouse_exited.connect(_on_unhovered)

func _on_hovered() -> void:
	if _upgrade == null: return
	ToolTipNode.create_and_show(self, ToolTip.new(_upgrade.get_id_name(), _upgrade.get_description()), Constants.Alignment.CENTER_TOP)

func _on_unhovered() -> void:
	if _upgrade == null: return
	ToolTipNode.remove_from(self)
