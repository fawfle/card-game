class_name ShieldNode extends Control

const SCENE: PackedScene = preload("res://scenes/combat/shield.tscn")

var _shield: Shield

@onready var shield_amount: Label = %ShieldAmount
@onready var progress_bar: ProgressBar = %ProgressBar

const COUNTER_COLOR: Color = Color(1.0, 0, 0, 1)
const PERMANENT_COLOR: Color = Color(0, 1.0, 0, 1)

static func create(shield: Shield) -> ShieldNode:
	var shield_node: ShieldNode = SCENE.instantiate()
	shield_node._shield = shield
	
	shield_node._shield.shield_removed.connect(shield_node.on_shield_removed)
	
	if shield.priority == Constants.ShieldPriority.COUNTER:
		shield_node.modulate = COUNTER_COLOR
	
	if shield.is_permanent:
		shield_node.modulate = PERMANENT_COLOR
	
	if shield.is_fragile:
		shield_node.modulate.a = 0.5
	
	return shield_node

func _ready() -> void:
	if _shield.is_permanent:
		progress_bar.visible = false

func _process(_delta: float) -> void:
	shield_amount.text = str(_shield.current_shield)
	
	if not _shield.is_permanent:
		progress_bar.max_value = _shield.get_duration()
		progress_bar.value = _shield.get_time_left()

func on_shield_removed() -> void:
	queue_free()
