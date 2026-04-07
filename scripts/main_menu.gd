extends Node3D
@onready var camera_3d: Camera3D = $Camera3D

@onready var menu_ui: Control = $Menu_Ui
@onready var bar: ProgressBar = $Menu_Ui/ProgressBar
@onready var enter_sound: AudioStreamPlayer3D = $Enter_sound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bar.value >= 100:
		switch_scene(GameManager.LEVEL1)
		
	if Input.is_action_just_pressed("Enter"):
		play_enter()
		await menu_ui.fill_bar()
		
	if Input.is_action_just_pressed("Pause or Cancel"):
		GameManager.get_tree().quit()
		
func switch_scene(scene):
	GameManager.switch_scene(scene)

func play_enter():
	var start_time = 0.6  # start at 5s
	var end_time = 1.21
	# Set the audio to the start time
	enter_sound.play(start_time)
	# Schedule stopping at the end time
	var duration = end_time - start_time
	await get_tree().create_timer(duration).timeout
	enter_sound.stop()
