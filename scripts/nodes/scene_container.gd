class_name SceneContainer extends Control

## Do not set directly. Use [method set_current_scene] instead.
var current_scene: Control = null

func set_current_scene(scene: Control):
	for child: Node in get_children():
		child.queue_free()
	
	current_scene = scene
	if scene == null: return
	
	if scene.get_parent():
		scene.reparent(self)
	else:
		add_child(scene)
