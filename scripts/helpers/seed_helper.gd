class_name SeedHelper extends StaticClass

const CHARACTERS = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"

static func get_random_seed(length: int = 10) -> String:
	var random_seed: String = ""
	for i in range(length):
		random_seed += CHARACTERS[randi_range(0, len(CHARACTERS) - 1)]
	return random_seed
