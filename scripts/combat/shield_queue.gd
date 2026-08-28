class_name ShieldQueue
##  Manages a list of shields, ensuring they're ordered correctly.
##
## Not an actual queue structure.

var shields: Array[Shield] = []

func get_front() -> Shield:
	if shields.is_empty(): return null
	return shields[0]

func add(shield: Shield) -> void:
	if shields.has(shield): push_error("shield already in queue.")
	shields.push_back(shield)
	order_shields()

func remove(shield: Shield) -> void:
	if not shields.has(shield): push_error("tried to remove shield not in queue.")
	shields.erase(shield)

func order_shields() -> void:
	var shields_temp: Array[Shield] = shields.duplicate() # want shallow
	var sorted_list: Array[Shield] = []
	for i in range(len(shields_temp)):
		var lowest_shield: Shield = get_highest_shield_priority(shields_temp)
		sorted_list.append(lowest_shield)
		shields_temp.erase(lowest_shield)
	
	shields.assign(sorted_list)

func get_highest_shield_priority(shield_list: Array[Shield]) -> Shield:
	if shield_list.is_empty(): return null
	var lowest_shield: Shield = shield_list[0]
	for i in range(1, len(shield_list)):
		if shield_list[i].priority > lowest_shield.priority and shield_list[i].get_time_left() > lowest_shield.get_time_left():
			lowest_shield = shield_list[i]
	return lowest_shield

func sort_by_shield_priority(shield_a: Shield, shield_b: Shield) -> bool:
	return shield_a.priority > shield_b.priority
