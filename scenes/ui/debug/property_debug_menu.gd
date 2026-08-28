class_name PropertyDebugMenu extends Control


@export var target: Node = null

@export var display_property_data: Dictionary[String, String] = {}

@onready var left_column: VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainerLeft
@onready var right_column: VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainerRight

var display_properties: Array[DisplayProperty] = []

var left_labels: Dictionary[DisplayProperty, Label] = {}
var right_labels: Dictionary[DisplayProperty, Label] = {}

func _ready() -> void:
	if not OS.is_debug_build(): return
	
	if not target:
		hide()
		return
	
	for key in display_property_data.keys():
		display_properties.push_back(DisplayProperty.new(key, display_property_data.get(key)))
	
	for property in display_properties:
		var left_label := Label.new()
		left_label.text = property.label + ":"
		left_column.add_child(left_label)
		var right_label := Label.new()
		right_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		right_label.clip_text = true
		right_column.add_child(right_label)
		
		left_labels.set(property, left_label)
		right_labels.set(property, right_label)
	
	show()

func _process(_delta: float) -> void:
	if not target: return
	
	for property in display_properties:
		right_labels.get(property).text = str(property.execute(target))

class DisplayProperty:
	var label: String
	var expression: Expression = Expression.new()
	func _init(label_: String, expression_: String = "") -> void:
		label = label_
		expression.parse(expression_)
	
	func execute(instance: Object):
		return expression.execute([], instance)
