class_name UpgradeHook extends StaticClass
## Hooks for applying upgrades.
##
## Separated from normal hooks for convenience. Upgrades being precomputed makes sense and makes accessing the actual values much easier.

static func upgrade_damage(card: CardModel, amount: float) -> float:
	var damage: float = amount
	for upgrade: UpgradeModel in card.upgrades:
		damage += upgrade.upgrade_damage_additive(damage)
	for upgrade: UpgradeModel in card.upgrades:
		damage *= upgrade.upgrade_damage_multiplicative(damage)
	return damage

static func upgrade_shield_amount(card: CardModel, amount: float) -> float:
	var shield_amount: float = amount
	for upgrade: UpgradeModel in card.upgrades:
		shield_amount += upgrade.upgrade_shield_additive(shield_amount)
	for upgrade: UpgradeModel in card.upgrades:
		shield_amount *= upgrade.upgrade_shield_multiplicative(shield_amount)
	return shield_amount

static func upgrade_card_duration(card: CardModel, amount: float) -> float:
	var card_duration: float = amount
	for upgrade: UpgradeModel in card.upgrades:
		card_duration += upgrade.upgrade_duration_additive(card_duration)
	for upgrade: UpgradeModel in card.upgrades:
		card_duration *= upgrade.upgrade_duration_multiplicative(card_duration)
	return card_duration
