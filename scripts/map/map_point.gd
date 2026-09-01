class_name MapPoint
## A point on a map.
##
## Stores high level data about the TYPE of map point, but doesn't store information about the room the point may contain.

var point_type: Constants.MapPointType

var position: Vector2

var visited: bool = false

func _init(type: Constants.MapPointType) -> void:
	point_type = type
