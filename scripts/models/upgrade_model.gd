@abstract
class_name UpgradeModel extends AbstractModel
## An abstract upgrade.
##
## Upgrades are modifiers to cards that change them. Their effects are usually applied before other modifiers since they are "part of the card".
## Upgrades are "dumber" than normal hooks since the Hook handler calls them more directly/specifically.
## Can do simple things like modify damage/shield, apply debuffs, etc.

var card: CardModel

func on_play() -> void:
	pass

func upgrade_damage_additive(damage_amount: float) -> float:
	return 0

func upgrade_damage_multiplicative(damage_amount: float) -> float:
	return 1.0

func upgrade_shield_additive(shield_amount: float) -> float:
	return 0

func upgrade_shield_multiplicative(shield_amount: float) -> float:
	return 1.0
