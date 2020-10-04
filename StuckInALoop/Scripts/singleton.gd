extends Node

var thread

func _ready():
	thread = Thread.new()
	
func load_scene(scene_name):
	if thread.is_active():
		thread.wait_to_finish()
	else:
		thread.start(self, "thread_load_scene", scene_name, 2)

func thread_load_scene(scene_name):
	var loading_scene = load(scene_name)
	call_deferred("thread_finish", loading_scene)

func thread_finish(scene):
	thread.wait_to_finish()
	get_tree().change_scene_to(scene)
	
func _exit_tree():
	thread.wait_to_finish()
