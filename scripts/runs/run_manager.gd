class_name RunManager
## Manages actual runs.
##
## Singleton accessed with static [member RunManager.instance]. Choosing instance of globals b/c why not, it makes it less editor dependent (plagiarism).

static var instance: RunManager = RunManager.new()

var run_state: RunState = null

## Do everything required to setup a new run.
func set_up_new_run(state: RunState):
	if run_state != null: push_error("cannot start new run while another run is active. Make sure to clear the state.")
	run_state = state

func enter_room(room: CombatRoom) -> void:
	room.enter(run_state)
