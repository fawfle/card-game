class_name SetupEffect extends EffectModel
## Increases damage of next attack
##
## Honestly some of the most "stolen" code from STS2. Specifically, their solution to letting vigor apply to previews while also removing it.

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

func modify_damage_additive(target: Creature, dealer: Creature, _damage_amount: float, attack_card_source: CardModel) -> float:
	if _attack_to_modify and dealer == _attack_to_modify.attacker and target in _attack_to_modify.targets and _attack_to_modify.card_source == attack_card_source:
		return amount
	# More or less taken from STS2. If there is an attack, we modify is correctly. If not, the effect still applies for previews.
	# Theoretically, the owner could deal damage (without an attack) and have this apply. STS2 has an "unpowered attack" flag for stuff that could
	# possibly deal damage "from" the creature without an attack.
	# WARNING: could possibly lead to setup applying to stuff it shouldn't and not being properly removed.
	if _attack_to_modify == null and owner == dealer:
		return amount
	
	
	return 0.0

func after_attack(attack: AttackCommand) -> void:
	if attack == _attack_to_modify:
		EffectCommand.modify_amount(self, -_amount_when_attack_started)
