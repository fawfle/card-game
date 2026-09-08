@abstract
class_name CardPoolModel extends AbstractModel
## A collection of cards that happens to be a model.
##
## Used to organize card sets (like character or location specific cards)

var all_cards: Array[CardModel]

## Called automatically by the class. Acess with [member all_cards].
@abstract func _generate_all_cards() -> Array[CardModel]

func _after_model_db_initialized() -> void:
	super._after_model_db_initialized()
	all_cards = _generate_all_cards()

## Get a random set of [param count] cards. (no duplicates)
func get_random_set(count: int) -> Array[CardModel]:
	if count > all_cards.size(): push_error("cannot get a set larger than the size of all_cards")
	
	var card_set: Array[CardModel] = []
	
	while card_set.size() < count:
		var card: CardModel = all_cards.pick_random()
		if not card_set.has(card): card_set.append(card)
	
	return card_set
