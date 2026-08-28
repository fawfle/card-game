class_name ShieldNode extends Control

const SCENE: PackedScene = preload("res://scenes/combat/shield.tscn")

var _shield: Shield

static func create(shield: Shield) -> ShieldNode:
	var shield_node: ShieldNode = SCENE.instantiate()
	shield_node._shield = shield
	
	shield_node._shield.shield_removed.connect(shield_node.on_shield_removed)
	
	return shield_node

func on_shield_removed() -> void:
	queue_free()
