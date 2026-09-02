class_name HealthBar extends ProgressBar

var creature: Creature = null

@onready var health_label: Label = %HealthLabel

@onready var shield_icon: Panel = %ShieldIcon
@onready var shield_label: Label = %ShieldLabel
@onready var shield_container: VBoxContainer = %ShieldContainer


func set_creature(set_creature: Creature) -> void:
	if creature:
		push_error("should not reassign a HealthBar's creature.")
		return
	
	creature = set_creature
	creature.on_shield_added.connect(_on_shield_added)
	creature.on_shield_removed.connect(_on_shield_removed)
	creature.on_max_hp_changed.connect(_on_creature_health_changed)
	creature.on_current_hp_changed.connect(_on_creature_health_changed)
	
func update_display() -> void:
	max_value = creature.max_hp
	value = creature.current_hp
	
	health_label.text = "%d/%d" % [value, max_value]
	
	shield_icon.visible = not creature.shield_queue.shields.is_empty()
	shield_label.text = str(creature.shield_queue.get_total_shield())
	
	sort_shields()

func _on_creature_health_changed(_old: float, _new: float):
	update_display()

func _on_shield_added(shield: Shield) -> void:
	var shield_node: ShieldNode = ShieldNode.create(shield)
	shield_container.add_child(shield_node)
	update_display()

func _on_shield_removed(shield: Shield) -> void:
	update_display()

func sort_shields() -> void:
	var children: Array[ShieldNode] = []
	children.assign(shield_container.get_children())
	for shield: Shield in creature.shield_queue.shields:
		for child: ShieldNode in children:
			if child._shield == shield:
				child.move_to_front()
				break
