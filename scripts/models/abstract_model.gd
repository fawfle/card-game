@abstract
class_name AbstractModel
## A base class for objects related to the core gameplay.
##
## Has a custom [method duplicate].

@warning_ignore_start("unused_parameter")

var is_mutable: bool = false

var is_base: bool:
	get(): return not is_mutable

## An id for identifying the model.
var id: String = ""

func _init() -> void:
	id = get_id_name()

## Create a mutable clone. When cloning a base instance, consider using [clone_mutable_from_base].
func clone_mutable() -> AbstractModel:
	## TODO: Make sure duplicate here actually works. If not, implement a custom copy function.
	var model: AbstractModel = _duplicate()
	model.is_mutable = true
	after_cloned()
	return model

## Create a mutable clone from the base instance. When applicable, theoretically more explicity/"safer" than [method clone_mutable].
func clone_mutable_from_base() -> AbstractModel:
	assert_base()
	return clone_mutable()

## A custom internal memberwise duplication method. Does not explicitly set [member is_mutable]. [br][br]
## NOTE/WARNING: performs some internal garbage, like temporarily making the objects mutable to avoid throwing on [method assert_mutable].
func _duplicate() -> AbstractModel:
	var model: AbstractModel = get_script().new()
	var property_list: Array[Dictionary] = get_property_list()
	var was_mutable: bool = is_mutable
	is_mutable = true
	model.is_mutable = true
	for property in property_list:
		model.set(property["name"], get(property["name"]))
	is_mutable = was_mutable
	model.is_mutable = was_mutable
	return model

func assert_mutable() -> void:
	if not is_mutable: push_error("base model used in place of mutable model")

func assert_base() -> void:
	if is_mutable: push_error("mutable model used in place of base model")

## WARNING: UNUSED? Runs after a clone is created. Useful for resetting properties or clearing references.
func after_cloned() -> void:
	pass

# WARNING: UNUSED. Can be used for automating things like image sources based on script name, which seems nice.
## Returns the id_name of this model
func get_id_name() -> String:
	return (get_script() as Script).get_global_name()

# WARNING: UNUSED
## Runs before a creature attacks. [br][br]
## For multi-hit attacks, this will only run once. See [method before_damage_taken] which will run before each hit. [br][br]
## Combat only.
func before_attack(attack) -> void:
	pass

# WARNING: UNUSED
## Runs after a creature attacks. [br][br]
## For multi-hit attacks, this will only run once. See [method after_damage_taken] which will run after each hit. [br][br]
## Combat only.
func after_attack(attack) -> void:
	pass

# WARNING: UNUSED
## Runs after a card is drawn. [br][br]
## Combat only.
func after_card_drawn(card: CardModel) -> void:
	pass

# WARNING: UNUSED
## Runs after a card is discarded. [br][br]
## Combat only.
func after_card_discarded(card: CardModel) -> void:
	pass

# WARNING: UNUSED
# WARNING: sts2 uses a cloned_by parameter to "stop copy effect recursion".
## Runs after a card moves from one pile to another. [br][br]
## The new pile is stored in [member card.pile].
func after_card_changes_piles(card: CardModel, old_pile) -> void:
	pass

# WARNING: UNUSED
## Runs after the players draw pile is shuffled. [br][br]
## Combat only.
func after_shuffle() -> void:
	pass


# WARNING: UNUSED
## Runs after the players hand becomes empty. [br][br]
## Combat only.
func after_hand_emptied() -> void:
	pass

# WARNING: UNUSED
## Runs before a card is played. [br][br]
## Combat only.
func before_card_played(card_play: CardPlay) -> void:
	pass

# WARNING: UNUSED
## Runs after a card is played. [br][br]
## Combat only.
func after_card_played(card_play: CardPlay) -> void:
	pass

# WARNING: UNUSED
## Runs before a card exits play. [br][br]
## NOTE: This will run even if the card is instant, though it should execute immediately. [br][br]
## Combat only.
func before_card_exits(card) -> void:
	pass

# WARNING: UNUSED
## Runs after a card exits play. [br][br]
## NOTE: This will run even if the card is instant, though it should execute immediately. [br][br]
## Combat only.
func after_card_exits(card) -> void:
	pass

# WARNING: UNUSED
## Runs before a card is removed from the deck.
func before_card_removed(card) -> void:
	pass

# WARNING: UNUSED
## Runs before combat starts.
func before_combat_start() -> void:
	pass

# WARNING: UNUSED
## Runs after combat ends.
func after_combat_end() -> void:
	pass

# WARNING: UNUSED
## Runs after any creature's HP is changed for any reason (damage, heal, etc.). Can happen out of combat.
func after_current_hp_changed(creature, delta) -> void:
	pass

# WARNING: UNUSED
## Runs before damage is dealt to a creature (regardless of actual damage).
func before_damage_dealt() -> void:
	pass

# WARNING: UNUSED
## Runs after damage is dealt to a creature (regardless of actual damage). [br][br]
## Different from [method after_damage_taken] since it runs regardless of the creature's state. Also semantics.
func after_damage_given() -> void:
	pass

# WARNING: UNUSED
## Runs after damage is taken by a creature (regardless of actual damage). [br][br]
## Different from [method after_damage_given] since it will NOT run if the creature dies. For example, this can be to avoid updating statuses. Also semantics.
func after_damage_taken() -> void:
	pass

# WARNING: UNUSED
## Runs before a creature dies.
func before_death() -> void:
	pass

# WARNING: UNUSED
## Runs after a creature dies.
func after_death() -> void:
	pass

# WARNING: UNUSED
## Runs after ethos is spent. [br][br]
## Combat only.
func after_ethos_spent() -> void:
	pass

# WARNING: UNUSED
## Runs after logos is spent. [br][br]
## Combat ony.
func after_logos_spent() -> void:
	pass

# WARNING: UNUSED
## Modify the player's max pathos.
func modify_max_pathos(max_pathos: float) -> float:
	return max_pathos

# WARNING: UNUSED
## Modify the player's max logos.
func modify_max_logos(max_logos: float) -> float:
	return max_logos

# WARNING: UNUSED
## Add to the amount that will be dealt.
func modify_damage_additive(target: Creature, dealer: Creature, damage_amount: float, card_source: CardModel) -> float:
	return 0

# WARNING: UNUSED
## Multiply the amount that will be dealt.
func modify_damage_multiplicative(target: Creature, dealer: Creature, damage_amount: float, card_source: CardModel) -> float:
	return 1.0

# WARNING: UNUSED
## Add to the amount of shield gained.
func modify_shield_additive(creature: Creature, shield_amount: float, card_source: CardModel) -> float:
	return 0

# WARNING: UNUSED
## Multiply the amount of shield gained.
func modify_shield_multiplicative(creature: Creature, shield_amount: float, card_source: CardModel) -> float:
	return 1.0

# WARNING: UNUSED. May need more hooks for order (modify_attack_early, modify_attack_late).
## Modify an attack. This is where in play card effects should be directly handled (such as shield).
func modify_attack(dealer, target, attack, card) -> float:
	return 1.0
