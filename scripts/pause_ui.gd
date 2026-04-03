extends Control

func _process(delta: float) -> void:		
	if Input.is_action_just_pressed("Pause or Cancel") and get_tree().paused:
		get_tree().paused = false
		visible = false
		
	elif Input.is_action_just_pressed("Home") and get_tree().paused:
		GameManager.switch_scene(GameManager.MENU)
		get_tree().paused = false
