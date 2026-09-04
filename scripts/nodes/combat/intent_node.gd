class_name IntentNode extends Control
## Visuals for what move an enemy will perform

const SCENE = preload("res://scenes/combat/intent.tscn")

var _intent: AbstractIntent
var _creature_node: CreatureNode

@onready var icon: TextureRect = %Icon
@onready var radial_progress_bar: TextureProgressBar = %RadialProgressBar
@onready var label: Label = %Label

static func create(intent: AbstractIntent, creature_node: CreatureNode) -> IntentNode:
	var intent_node: IntentNode = SCENE.instantiate()
	intent_node._intent = intent
	intent_node._creature_node = creature_node
	if not creature_node.is_enemy: push_error("intent creature_node must be an enemy.")
	return intent_node

func _ready() -> void:
	mouse_entered.connect(_on_hovered)
	mouse_exited.connect(_on_unhovered)
	
	update_visuals()
	
	HelperControl.check_hover(self, _on_hovered)

func _process(_delta: float) -> void:
	update_progress_bar()

func update_visuals() -> void:
	icon.texture = _intent.get_icon()
	label.text = _intent.get_label(_creature_node.entity, CombatManager.instance.combat_state.allies)
	update_progress_bar()

func update_progress_bar() -> void:
	radial_progress_bar.max_value = _creature_node.entity.enemy.next_move.get_move_time()
	radial_progress_bar.value = _creature_node.entity.enemy.move_state_machine.time_spent_in_state

func _on_hovered() -> void:
	_creature_node.show_hover_tips(_intent.get_hover_tip(_creature_node.entity, CombatManager.instance.combat_state.allies))

func _on_unhovered() -> void:
	_creature_node.hide_hover_tips()
