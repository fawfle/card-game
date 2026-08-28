@abstract
class_name CharacterModel extends AbstractModel
## Represents a character.
##
## NOTE: these probably don't need to be models since I don't really use [property AbstractModel.id] but we're copycats here. There are goodish reasons for STS2
## to make them AbstractModels (like serialization I think) but I don't think those apply to my game. Nevertheless, it makes copying some concepts I want to use,
## like [ModelDb] make more sense.

@abstract func get_starting_max_hp() -> int

@abstract func get_starting_max_pathos() -> int

@abstract func get_starting_max_logos() -> int

## How many cards the player starts with at the beginning of combat.
@abstract func get_starting_initial_card_count() -> int

## How long it takes to draw a card.
@abstract func get_starting_draw_time() -> float

## How long it takes to gain 1 pathos.
@abstract func get_starting_pathos_time() -> float

@abstract func get_starting_deck() -> Array[CardModel]
