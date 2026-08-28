class_name GameNode extends Control

static var instance: GameNode = null

@onready var root_scene_container: SceneContainer = %RootSceneContainer

func get_run_node() -> RunNode: return root_scene_container.current_scene if root_scene_container.current_scene is RunNode else null


func _init() -> void:
	if instance != null and instance != self:
		push_warning("There should only be one instance of NodeGame.")
		queue_free()
		return
	instance = self

func _enter_tree() -> void:
	ModelDb.initialize()

func _ready() -> void:
	start_run(ModelDb.character(TestCharacter))

func start_run(character: CharacterModel, run_seed: String = ""):
	if run_seed == "": run_seed = SeedHelper.get_random_seed()
	var run_state: RunState = RunState.new(Player.create_for_new_run(character), run_seed)
	RunManager.instance.set_up_new_run(run_state)
	root_scene_container.set_current_scene(RunNode.create(run_state))
	
	var combat_state: CombatState = CombatState.new(run_state)
	var enemy: Creature = Creature.from_enemy(ModelDb.enemy(TestEnemy).clone_mutable_from_base())
	enemy.side = Constants.CombatSide.ENEMY
	combat_state.add_creature(enemy)
	
	CombatManager.instance.start_combat_from_state(run_state, combat_state)
