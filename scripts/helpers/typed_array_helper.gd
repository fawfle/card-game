class_name TypedHelper extends StaticClass
## Helpers to make stuff typed. Mainly typed arrays.
##
## Use to type arrays used directly as arguments. Assignment to a typed variable is what performs the conversion.

static func card_model_array(card: CardModel) -> Array[CardModel]:
	var array: Array[CardModel] = [card]
	return array
