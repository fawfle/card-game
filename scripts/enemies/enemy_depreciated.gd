class_name EnemyDepreciated extends Node2D

@export var health: int = 10
@export var attack_time: float = 1.0

@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	GameManager.current_enemy = self
	
	attack_timer.start(attack_time)
	attack_timer.timeout.connect(_on_attack_timer)

func _on_attack_timer() -> void:
	var attack: Attack = Attack.new()
	attack.damage = 1
	GameManager.enemy_attack.emit(attack)

func take_damage(damage: float):
	health = max(health - damage, 0)
