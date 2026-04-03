extends SpringArm3D

@export var min_limit_x : float
@export var max_limit_x : float
@export var mouse_acceleration := 0.005
@onready var player: CharacterBody3D = $".."

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and player.win == false:
		rotate_from_vector(event.relative * mouse_acceleration)

func rotate_from_vector(v: Vector2):
	if v.length() == 0: return
	rotation.y -= v.x
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
