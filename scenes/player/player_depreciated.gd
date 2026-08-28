class_name PlayerDepreciated extends Node2D

@export var health: int = 10

func _ready() -> void:
	GameManager.player = self
	GameManager.enemy_attack_hit.connect(_on_hit)

func _on_hit(attack: Attack) -> void:
	health -= attack.damage
