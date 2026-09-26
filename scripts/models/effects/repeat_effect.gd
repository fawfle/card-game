class_name RepeatEffect extends EffectModel

func get_icon() -> Texture2D: return preload("res://assets/icons/cycle.png")

func get_title() -> String: return "Repeat"

func get_description() -> String: return "The next %d cards that exit play go to the top of your draw pile." % amount

static func get_generic_description() -> String: return "Puts cards that exit at the top of your draw pile."

func modify_card_play_result_pile_and_position(card: CardModel, pile_type: Constants.PileType, _position_type: Constants.PilePositionType) -> PileLocation:
	if (owner.player and card.owner == owner.player) and pile_type != Constants.PileType.DISCARD:
		var location: PileLocation = PileLocation.new(Constants.PileType.DRAW, Constants.PilePositionType.TOP)
		# IDK if it's good to decrement before returning (weird nested hooks and stuff) but probably fine
		await EffectCommand.decrement_amount(self)
		return location
	
	return null
