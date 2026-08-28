class_name DamageEffect extends CardEffect

## What phase damage should be dealth
@export var phase: Phase = Phase.START

## Damage to deal on play end
@export var damage: int = 0

func on_play_start(card: Card):
	if phase != Phase.START: return
	card.deal_damage(damage)

func on_play_end(card: Card):
	if phase != Phase.END: return
	card.deal_damage(damage)

func _in_play_process(_card: Card, _delta: float):
	if phase != Phase.IN_PLAY_PROCESS: return
	push_error("Currently not supported")
