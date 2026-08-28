class_name CombatRoomNode extends Control
## Has [method create].

const SCENE: PackedScene = preload("res://scenes/rooms/combat_room.tscn")

static var instance: CombatRoomNode = null

var _combat_room: CombatRoom = null

@onready var ally_container: Control = $AllyContainer
@onready var player_marker: Marker2D = $AllyContainer/PlayerMarker
@onready var enemy_container: Control = $EnemyContainer
@onready var enemy_marker: Marker2D = $EnemyContainer/EnemyMarker
@onready var ui: CombatUi = %CombatUi

static func create(combat_room: CombatRoom) -> CombatRoomNode:
	var node: CombatRoomNode = SCENE.instantiate()
	node._combat_room = combat_room
	return node

func _ready() -> void:
	if instance != null and instance != self:
		queue_free()
		push_error("There should only be 1 instance of CombatRoomNode at a time.")
		return
	instance = self
	CombatManager.instance.combat_setup_completed.connect(_on_combat_setup_completed)

func _on_combat_setup_completed(_state: CombatState) -> void:
	create_creature_nodes()

func create_creature_nodes() -> void:
	for creature: Creature in _combat_room.combat_state.allies:
		add_creature(creature)
	for creature: Creature in _combat_room.combat_state.enemies:
		add_creature(creature)

func add_creature(creature: Creature) -> void:
	var creature_node: CreatureNode = CreatureNode.create(creature)
	if creature.side == Constants.CombatSide.ALLY:
		ally_container.add_child(creature_node)
		creature_node.global_position = player_marker.global_position
	elif creature.side == Constants.CombatSide.ENEMY:
		enemy_container.add_child(creature_node)
		creature_node.global_position = enemy_marker.global_position
	else:
		push_error("added enemy does not have a combat side.")
