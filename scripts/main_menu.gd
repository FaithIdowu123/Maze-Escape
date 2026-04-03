extends Node3D
@onready var camera_3d: Camera3D = $Camera3D

@onready var menu_ui: Control = $Menu_Ui
@onready var bar: ProgressBar = $Menu_Ui/ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bar.value >= 100:
		switch_scene(GameManager.LEVEL1)
		
	if Input.is_action_just_pressed("Enter"):
		await menu_ui.fill_bar()
		
	if Input.is_action_just_pressed("Pause or Cancel"):
		GameManager.get_tree().quit()
		
func switch_scene(scene):
	GameManager.switch_scene(scene)
