class_name ShieldEffect extends CardEffect

## Amount of shield granted while in play
@export var shield: int = 0

var shield_left: int = 0

func reset():
	shield_left = shield

func on_clash(card: Card, attack: Attack):
	if attack.damage == 0: return
	
	var shield_left_temp: int = shield_left - attack.damage
	attack.damage = max(attack.damage - shield_left, 0)
	
	shield_left = shield_left_temp
	card.update_card()
	
	if shield_left <= 0:
		card.exit_play()
