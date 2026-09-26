class_name PileLocation
## A simple data type that stores a [enum Constants.PileType] and [enum Constants.PilePositionType].
##
## Annoying and confusing, but it should only really be used in one place.

var pile_type: Constants.PileType
var position_type: Constants.PilePositionType

func _init(pile: Constants.PileType, position: Constants.PilePositionType) -> void:
	pile_type = pile
	position_type = position
