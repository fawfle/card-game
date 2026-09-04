class_name Map
## A map for a run.
##
## Not sure if I need a map rn. Kind of obligatory. Right now there are no choices.

var _map_length: int

var map_points: Array[MapPoint] = []

func _init(run_state: RunState, act: ActModel) -> void:
	_map_length = act.get_length()
	_generate_map()

func _generate_map() -> void:
	map_points.clear()
	
	for i in range(_map_length):
		var map_point: MapPoint = MapPoint.new(Constants.MapPointType.DEBATE)
		map_points.push_back(map_point)
