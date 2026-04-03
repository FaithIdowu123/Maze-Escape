extends Node3D

enum {IDLE,RUN,DANCE}
var curAnim := IDLE

@onready var anim_tree: AnimationTree = $AnimationTree

@export var blend_speed : int = 15
var run_val :float = 0
var dance_val :float= 0

func _physics_process(delta: float) -> void:
	handle_animation(delta)

func handle_animation(delta):
	match  curAnim:
		IDLE:
			run_val = lerpf(run_val, 0 , blend_speed * delta)
			dance_val = lerpf(dance_val, 0 , blend_speed * delta)
		RUN:
			run_val = lerpf(run_val, 1 , blend_speed * delta)
			dance_val = lerpf(dance_val, 0 , blend_speed * delta)
		DANCE:
			run_val = lerpf(run_val, 0 , blend_speed * delta)
			dance_val = lerpf(dance_val, 1 , blend_speed * delta)
	update_tree()
	
func update_tree():
	anim_tree["parameters/Run/blend_amount"] = run_val 
	anim_tree["parameters/Dance/blend_amount"] = dance_val 
