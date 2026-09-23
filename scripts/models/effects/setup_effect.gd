class_name SetupEffect extends EffectModel
## Increases damage of next attack

func get_title() -> String: return "Setup"

func get_description() -> String: return "Increases damage of next attack by %d" % amount

static func get_generic_description() -> String: return "Increases damage of next attack"

func get_icon() -> Texture2D: return preload("res://assets/icons/electric.png")

var _attack_to_modify: AttackCommand = null
var _amount_when_attack_started: int = 0

func before_attack(attack: AttackCommand) -> void:
	if attack.attacker == owner:
		_attack_to_modify = attack
		_amount_when_attack_started = amount

func after_attack(attack: AttackCommand) -> void:
	pass
	#if _attack_to_modify:
		#await 
