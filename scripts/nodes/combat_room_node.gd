class_name CombatRoomNode extends Control
## Has [method create].

const SCENE: PackedScene = preload("res://scenes/rooms/combat_room.tscn")

static var instance: CombatRoomNode:
	get(): return RunNode.instance.get_combat_room()

var _combat_room: CombatRoom = null

@onready var ally_container: Control = %AllyContainer
@onready var player_marker: Marker2D = %PlayerMarker
@onready var enemy_container: Control = %EnemyContainer
@onready var enemy_marker: Marker2D = %EnemyMarker
@onready var ui: CombatUi = %CombatUi

@onready var proceed_button: Button = %ProceedButton

static func create(combat_room: CombatRoom) -> CombatRoomNode:
	var node: CombatRoomNode = SCENE.instantiate()
	node._combat_room = combat_room
	return node

func _ready() -> void:
	CombatManager.instance.combat_setup_completed.connect(_on_combat_setup_completed)
	CombatManager.instance.combat_won.connect(_on_combat_won)
	
	proceed_button.pressed.connect(_on_proceed_button_pressed)
	proceed_button.visible = false

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

func remove_creature_node(creature_node: CreatureNode) -> void:
	creature_node.queue_free()

func get_creature_node(creature: Creature) -> CreatureNode:
	for creature_node: CreatureNode in ally_container.get_children():
		if creature_node.entity == creature:
			return creature_node
	
	for creature_node: CreatureNode in enemy_container.get_children():
		if creature_node.entity == creature:
			return creature_node
	
	return null

func _on_combat_won() -> void:
	proceed_button.visible = true

func _on_proceed_button_pressed() -> void:
	RunManager.instance.proceed_from_room()
