extends Node3D
@onready var key: Node3D = $Key
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

var can_pick : bool = false
var player : Node3D
var active : bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Enter") and can_pick:
		collision_shape_3d.disabled = true
		player.interactable = false
		player.pickup()
		player = null
		key.queue_free()
		active = false
		cpu_particles_3d.emitting = false
			
func _on_area_3d_body_entered(body: Node3D) -> void:
	if "pickup" in body:
		player = body
		player.interactable = true
		can_pick = true
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	if "pickup" in body:
		body.interactable = false
		player = null
		can_pick = false
