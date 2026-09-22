class_name AttackCommand
## Commands for attacks. Used as a builder.
##
## Builds an attack using chained methods, like tweens. NOT static like other commands. Execute with [method execute] and use [code]await[/code].

var damage: float = 0
var hit_count: int = 1
## The delay between hits for multi-hit attacks. Only matters if hit_count > 1.
var hit_delay: float = 0.50

var targets: Array[Creature] = []
var attacker: Creature = null:
	set(value):
		if attacker != null: push_error("Cannot change the attacker if it is already set.")
		attacker = value

var card_source: CardModel = null

var attacker_vfx: PackedScene = null

func _init(damage_amount: float) -> void:
	damage = damage_amount

## Set the number of times the attack be performed
func with_hit_count(count: int) -> AttackCommand:
	if count < 0: push_error("hit count shouldn't be less than 0.")
	hit_count = count
	return self

## Set the hit delay (only matters if multi-hit)
func set_hit_delay(delay: float) -> AttackCommand:
	if hit_count <= 1: push_error("This attack command is not currently a multi-hit, so hit_delay has no effect.")
	hit_delay = delay
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

## Execute the attack. This method should usually be awaited.
## NOTE: Calls a static method to keep a reference to itself. May have overhead, but prevents against a reference being lost, which is very
## difficult/annoying to detect. This is avoided by awaiting the execute method, but this removes any possibility of it occuring to be super safe.
func execute() -> void:
	await _execute_static(self)

## NOTE: if executed without await, a reference to the command will be lost and it will be freed without finishing. See [method execute].
func _execute_internal() -> void:
	for i in range(hit_count):
		CreatureCommand.play_animation(attacker, Constants.ATTACK_ANIMATION)
		CreatureCommand.damage_creatures(targets, attacker, damage, card_source)
		if i < hit_count - 1:
			var timer: float = 0
			while timer < hit_delay:
				await CombatManager.instance.combat_process_frame
				var delta: float = CombatManager.instance.last_delta
				timer += delta

## For internal use only. Use a static call to execute the command and ensure a reference is stored, even if the original execute method is called without await.
static func _execute_static(attack_command: AttackCommand) -> void:
	await attack_command._execute_internal()
