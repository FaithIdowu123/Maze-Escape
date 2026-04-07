extends CharacterBody3D
enum {IDLE,RUN,DANCE}

@onready var camera = $SpringArm3D/Camera3D
@onready var dance_timer: Timer = $Dance
@onready var idle_timer: Timer = $Idle
@onready var tim: Node3D = $Tim
@onready var walk_sound: AudioStreamPlayer3D = $Walk_sound

@export var walk_speed : float = 6.0
@export var run_speed : float = 8.0
var speed : float = 0
var keys : int = 0
var win: bool = false

var interactable :bool = false 
@export var blend_speed : int= 15
var run_val = 0
var dance_val = 0
# Start and end time in seconds
var start_time = 3.01  # start at 5s
var end_time = 3.52   # stop at 10s
var rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	if !win:
		move(delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func move(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	speed = walk_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward").rotated(-camera.global_rotation.y)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		tim.curAnim = RUN
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		var target_rotation = atan2(direction.x, direction.z)
		$Tim.rotation.y = lerp_angle($Tim.rotation.y, target_rotation, 0.15)
		if !walk_sound.playing:
			play_walk()
	else:
		tim.curAnim = IDLE
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func pickup():
	keys += 1
	print(keys)

func won():
	tim.curAnim = DANCE 
	dance_timer.start()

func _on_dance_timeout() -> void:
	tim.curAnim = IDLE
	idle_timer.start()

func _on_idle_timeout() -> void:
	won()

func play_walk():
	# Set the audio to the start time
	walk_sound.pitch_scale = rng.randf_range(0.7,1.3)
	walk_sound.play(start_time)
	# Schedule stopping at the end time
	var duration = end_time - start_time
	await get_tree().create_timer(duration).timeout
	walk_sound.stop()
