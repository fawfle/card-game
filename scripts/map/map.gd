class_name Map
## A map for a run.
##
## Not sure if I need a map rn. Kind of obligatory. Right now there are no choices.

var _map_length: int

var map_points: Array[MapPoint] = []

const UPGRADE_POSITIONS: Array[int] = [2]

func _init(run_state: RunState, act: ActModel) -> void:
	_map_length = act.get_length()
	_generate_map(act)

func _generate_map(act: ActModel) -> void:
	map_points.clear()
	
	for i in len(act.normal_encounter_sets) + len(UPGRADE_POSITIONS):
		var point_type: Constants.MapPointType = Constants.MapPointType.DEBATE
		if UPGRADE_POSITIONS.has(i): point_type = Constants.MapPointType.UPGRADE
		
		var map_point: MapPoint = MapPoint.new(point_type)
		map_points.push_back(map_point)
	
	if act.boss_encounter_set != null:
		var boss_point: MapPoint = MapPoint.new(Constants.MapPointType.BOSS)
		map_points.push_back(boss_point)
