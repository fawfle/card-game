class_name ShieldNode extends Control

const SCENE: PackedScene = preload("res://scenes/combat/shield.tscn")

var _shield: Shield

@onready var shield_amount: Label = %ShieldAmount
@onready var progress_bar: ProgressBar = %ProgressBar

static func create(shield: Shield) -> ShieldNode:
	var shield_node: ShieldNode = SCENE.instantiate()
	shield_node._shield = shield
	
	shield_node._shield.shield_removed.connect(shield_node.on_shield_removed)
	
	return shield_node

func _process(_delta: float) -> void:
	shield_amount.text = str(_shield.current_shield)
	
	progress_bar.max_value = _shield.get_duration()
	progress_bar.value = _shield.get_time_left()

func on_shield_removed() -> void:
	queue_free()
