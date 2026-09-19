@abstract
class_name UpgradeModel extends AbstractModel
## An abstract upgrade.
##
## Upgrades are modifiers to cards that change them. Their effects are usually applied before other modifiers since they are "part of the card".
## Upgrades are "dumber" than normal hooks since the Hook handler calls them more directly/specifically.
## Can do simple things like modify damage/shield, apply debuffs, etc.
## NOTE: each should have a "fake abstract method" [method set_amounts]. It's fake so they can take advantage of function signatures and typing. The method should return itself (typed as a specific upgrade).

var card: CardModel

## Get the standalone description of the upgrade
func get_description() -> String: return "Broken upgrade description"

## Get an optional description to add to a card. Use for bonus effects like draw.
func get_card_description() -> String: return ""

func get_color() -> Color: return Color(0.863, 0.718, 0.0, 1.0)

## Override. If the upgrade can be applied to a card. NOTE: currently somewhat limited. Could improve to make card selection easier.
func can_apply(_card_model: CardModel) -> bool: return true

func can_apply_to_any(card_pile: CardPile) -> bool:
	for pile_card in card_pile.cards:
		if can_apply(pile_card): return true
	return false

func on_play() -> void:
	pass

func upgrade_damage_additive(_damage_amount: float) -> float:
	return 0

func upgrade_damage_multiplicative(_damage_amount: float) -> float:
	return 1.0

func upgrade_shield_additive(_shield_amount: float) -> float:
	return 0

func upgrade_shield_multiplicative(_shield_amount: float) -> float:
	return 1.0

func upgrade_duration_additive(_duration_amount: float) -> float:
	return 0

func upgrade_duration_multiplicative(_duration_amount: float) -> float:
	return 1.0
