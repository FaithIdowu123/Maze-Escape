extends Node

const MENU = "res://scenes/main_menu.tscn"
const LEVEL1 = "res://scenes/main.tscn"

var current_scene: Node = null
var is_loading := false

var fade_scene := preload("res://scenes/fade.tscn")
var fade

func _ready():
	current_scene = get_tree().current_scene
	
	fade = fade_scene.instantiate()
	add_child(fade)
	
	switch_scene(MENU)

func switch_scene(scene_path: String):
	if is_loading:
		return
	
	if scene_path == "":
		print("❌ Scene path is empty")
		return
	
	is_loading = true
	call_deferred("_switch_scene", scene_path)

func _switch_scene(scene_path: String):
	print("Switching to:", scene_path)

	await fade.fade_out()

	var packed_scene = load(scene_path)
	
	if packed_scene == null:
		print("❌ Scene load failed in thread")
		return null
		
	var instance = packed_scene.instantiate()
	
	if current_scene:
		current_scene.queue_free()

	add_child(instance)
	get_tree().current_scene = instance
	current_scene = instance

	await fade.fade_in()

	is_loading = false
	

	
