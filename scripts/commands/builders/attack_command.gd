class_name AttackCommand
## Commands for attacks. Used as a builder.
##
## Builds an attack using chained methods, like tweens. NOT static like other commands. Execute with [method execute].

var damage: float = 0
## TODO: Add dynamic vars

var targets: Array[Creature] = []
var attacker: Creature = null:
	set(value):
		if attacker != null: push_error("Cannot change the attacker if it is already set.")
		attacker = value

var card_source: CardModel = null

func with_damage(amount: int) -> AttackCommand:
	damage = amount
	return self

func targeting(creature: Creature) -> AttackCommand:
	targets = [creature]
	return self

func from(creature: Creature) -> AttackCommand:
	attacker = creature
	return self

## Set the attack source to be this card. Automatically sets attacker to the player's creature so no need to call [method from].
func from_card(card: CardModel) -> AttackCommand:
	card_source = card
	attacker = card.owner.creature
	return self

## Sets the attack source to be an enemy.s
func from_enemy(enemy: EnemyModel) -> AttackCommand:
	attacker = enemy.creature
	return self

## Set this attack's targets to be every creature on the opposing [enum Constants.CombatSide].
func targeting_all_opponents(combat_state: CombatState) -> AttackCommand:
	if attacker == null: push_error("cannot target opponents without an attacker.")
	match attacker.side:
		Constants.CombatSide.ALLY: targets = combat_state.enemies
		Constants.CombatSide.ENEMY: targets = combat_state.allies
	
	return self

## Execute the attack.
func execute() -> void:
	CreatureCommand.damage_creatures(targets, attacker, damage, card_source)
