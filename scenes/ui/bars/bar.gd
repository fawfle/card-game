class_name PropertyBar extends ProgressBar

@export var target: Node = null
@export var property: String = ""

@onready var label: Label = $Label

func _ready() -> void:
	max_value = target.get(property)

func _process(_delta: float) -> void:
	value = target.get(property)
	
	label.text = "%d/%d" % [value, max_value]

func set_target_property(target_: Object, property_: String, max_value_: float):
	target = target_
	property = property_
	max_value = max_value_
