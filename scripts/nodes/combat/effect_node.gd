class_name EffectNode extends Control
## Visuals for what move an enemy will perform

const SCENE = preload("res://scenes/combat/effect.tscn")

var _effect: EffectModel
var _creature_node: CreatureNode

@onready var duration_progress: ProgressBar = %DurationProgress
@onready var icon: TextureRect = %Icon
@onready var amount: Label = %Amount

static func create(effect: EffectModel, creature_node: CreatureNode) -> EffectNode:
	var effect_node: EffectNode = SCENE.instantiate()
	effect_node._effect = effect
	effect_node._creature_node = creature_node
	return effect_node

func _ready() -> void:
	mouse_entered.connect(_on_hovered)
	mouse_exited.connect(_on_unhovered)
	
	icon.texture = _effect.get_icon()
	
	if _effect.is_permanent:
		duration_progress.max_value = 1
		duration_progress.value = 1
	
	HelperControl.check_hover(self, _on_hovered)

# at this point, I'm just gonna start putting stuff in _process.
func _process(_delta: float) -> void:
	amount.text = str(_effect.amount)
	
	if not _effect.is_permanent:
		duration_progress.max_value = _effect.get_duration()
		duration_progress.value = _effect.get_time_left()

func _on_hovered() -> void:
	_creature_node.show_hover_tips(_effect.get_hover_tip())

func _on_unhovered() -> void:
	_creature_node.hide_hover_tips()
