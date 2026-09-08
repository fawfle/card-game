class_name VfxCommand

const PADDING_X: float = 50

# TODO: make freeing logic better
static func play_on_creature_front(creature: Creature, vfx_scene: PackedScene) -> void:
	var creature_node: CreatureNode = creature.get_creature_node()
	
	var local_position = Vector2(creature_node.hitbox.size.x + PADDING_X, -creature_node.hitbox.size.y)
	
	var node: Node2D = vfx_scene.instantiate()
	creature_node.visuals_container.add_child(node)
	node.position = local_position
	
	await creature_node.get_tree().create_timer(0.5).timeout
	
	node.queue_free()
