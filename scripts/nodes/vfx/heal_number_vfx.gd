class_name HealNumberVfx extends Node2D

const SCENE: PackedScene = preload("res://scenes/vfx/heal_number_vfx.tscn")

var _text: String

@onready var label: Label = %Label

static func create(target: Creature, amount: int) -> HealNumberVfx:
	var vfx: HealNumberVfx = SCENE.instantiate()
	vfx._text = str(amount)
	vfx.global_position = target.get_creature_node().global_position + Vector2(0, -100)
	return vfx

func _ready() -> void:
	label.text = _text
	play()

func play() -> void:
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(label, "position:y", -100, 1.00).set_ease(Tween.EaseType.EASE_OUT).set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property(label, "modulate:a", 0, 1.00).set_ease(Tween.EaseType.EASE_IN).set_trans(Tween.TransitionType.TRANS_QUAD)
	await tween.finished
	queue_free()
