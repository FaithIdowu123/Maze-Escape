extends Node3D
@onready var key: Node3D = $Key
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D
@onready var key_sound: AudioStreamPlayer3D = $Key_sound

var can_pick : bool = false
var player : Node3D
var active : bool = true
# Start and end time in seconds
var start_time = 0.10  # start at 5s
var end_time = 0.52  # stop at 10s

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Enter") and can_pick:
		play_key()
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

func play_key():
	# Set the audio to the start time
	key_sound.play(start_time)
	# Schedule stopping at the end time
	var duration = end_time - start_time
	await get_tree().create_timer(duration).timeout
	key_sound.stop()
