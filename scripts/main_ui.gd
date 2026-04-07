extends Control

@onready var win_screen: Control = $Win_screen
@onready var game_ui: Control = $Game_Ui
@onready var pause_ui: Control = $Pause_Ui
@onready var main: Node3D = $".."
@onready var pause_sound: AudioStreamPlayer3D = $Pause_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause or Cancel") and !get_tree().paused and !main.won:
		play_pause()
		pause_ui.visible = true
		game_ui.visible = false
		get_tree().paused = true			
	elif Input.is_action_just_pressed("Pause or Cancel") and get_tree().paused:
		play_pause()
		get_tree().paused = false
		game_ui.visible = true
		pause_ui.visible = false
	elif Input.is_action_just_pressed("Home") and get_tree().paused:
		play_pause()
		GameManager.switch_scene(GameManager.MENU)
		get_tree().paused = false
		
func play_pause():
	var start_time = 0.00  # start at 5s
	var end_time = 0.50
	# Set the audio to the start time
	pause_sound.play(start_time)
	# Schedule stopping at the end time
	var duration = end_time - start_time
	await get_tree().create_timer(duration).timeout
	pause_sound.stop()
