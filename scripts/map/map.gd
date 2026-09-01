class_name Map
## A map for a run.
##
## Not sure if I need a map rn. Kind of obligatory. Right now there are no choices.

const map_length: int = 10

var map_points: Array[MapPoint] = []

func _init(run_state: RunState) -> void:
	_generate_map()

func _generate_map() -> void:
	map_points.clear()
	
	for i in range(map_length):
		var map_point: MapPoint = MapPoint.new(Constants.MapPointType.DEBATE)
		map_points.push_back(map_point)
