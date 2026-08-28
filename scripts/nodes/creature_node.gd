class_name CreatureNode extends Control

static var SCENE: PackedScene = preload("res://scenes/combat/creature.tscn")

var entity: Creature = null

var is_enemy: bool:
	get(): return entity.enemy != null if entity != null else false

@onready var hitbox: Control = %Hitbox
@onready var health_bar: HealthBar = %HealthBar
@onready var intents_container: HBoxContainer = %IntentsContainer

static func create(creature: Creature) -> CreatureNode:
	var creature_node: CreatureNode = SCENE.instantiate()
	creature_node.entity = creature
	if creature_node.entity.enemy:
		creature_node.entity.enemy.move_changed.connect(creature_node._on_enemy_state_changed)
	return creature_node

func _ready() -> void:
	CombatManager.instance.combat_started.connect(_on_combat_started)
	health_bar.set_creature(entity)
	
	health_bar.update_display()

func _on_combat_started(_combat_state: CombatState) -> void:
	if entity.enemy: update_intents()

func update_intents() -> void:
	if entity.enemy == null: push_error("Only enemies have intents.")
	
	var intents: Array[AbstractIntent] = entity.enemy.next_move.intents
	
	for node: Node in intents_container.get_children():
		node.queue_free()
	
	for intent: AbstractIntent in intents:
		var intent_node: IntentNode = IntentNode.create(intent, self)
		intents_container.add_child(intent_node)

func _on_enemy_state_changed(_state: MoveState):
	update_intents()

func show_hover_tips(hover_tip: HoverTip) -> void:
	hide_hover_tips()
	HoverTipNode.create_and_show(hitbox, hover_tip)

func hide_hover_tips() -> void:
	HoverTipNode.remove(hitbox)
