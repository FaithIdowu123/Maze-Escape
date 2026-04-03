extends Node3D

@onready var show_mouse = true
@onready var collision_shape_3d: CollisionShape3D = $Finish_Line/CollisionShape3D
@onready var finish_line: Area3D = $Finish_Line
@onready var pause_ui: Control = $Main_ui/Pause_Ui
@onready var game_ui: Control = $Main_ui/Game_Ui
@onready var character: CharacterBody3D = $Player
@onready var game_ui_interact: Control = $Main_ui/Game_Ui/interact
@onready var goal: Label = $Main_ui/Game_Ui/goal
@onready var proximity: Label = $Main_ui/Game_Ui/proximity
@onready var keys: Node3D = $keys

@onready var keys_loc = keys.get_children()
@onready var keys_needed = keys_loc.size()

var nearest:float = 9999999
var distance: float
var can_open : bool = false
var player : Node3D
var won : bool = false 

func _ready() -> void:
	DisplayServer.mouse_set_mode(2)

func _process(delta: float) -> void:
	if won == false:
		if character.keys < keys_needed:
			goal.text = "Find the key " + str(character.keys) + "/" + str(keys_needed) + "."
		else:
			goal.text = "Find the exit."
		find_proximity()
			
		if character.interactable:
			game_ui_interact.visible = true
		else:
			game_ui_interact.visible = false

		# Win condition
		if Input.is_action_just_pressed("Enter") and can_open and character.keys >= keys_needed:
			collision_shape_3d.disabled = true
			character.interactable = false
			player.win = true
			won = true
			$Main_ui/Win_screen.visible = true
			player.won()
			player = null
			game_ui.visible = false
			finish_line.queue_free()
	else:
		if Input.is_action_just_pressed("Enter"):
			switch_scene(GameManager.LEVEL1)
		elif Input.is_action_just_pressed("Pause or Cancel"):
			switch_scene(GameManager.MENU)

func _on_finish_line_body_entered(body: Node3D) -> void:
	if "won" in body and character.keys >= keys_needed:
		player = body 
		character.interactable = true
		can_open = true

func _on_finish_line_body_exited(body: Node3D) -> void:
	if "won" in body:
		character.interactable = false
		player = null
		can_open = false
		
func find_proximity():
	var pos1 = character.global_position
	if character.keys < keys_needed:
		for item: Node3D in keys_loc:
			if item.active:
				var pos2 = item.global_position
				distance = pos1.distance_to(pos2)
				if distance < nearest:
					nearest = distance
		if nearest >= 1000: 
			var km = nearest/1000
			proximity.text = "Nearest Key is " + str(km).pad_decimals(1) + " kms away."
		else:
			proximity.text = "Nearest Key is " + str(nearest).pad_decimals(1) + " meters away."
		nearest = 999999999999
	else:
		if finish_line:
			var pos2 = finish_line.global_position
			distance = pos1.distance_to(pos2)
			nearest = distance
			if nearest >= 1000: 
				var km = nearest/1000
				proximity.text = "The Gate is " + str(km).pad_decimals(1) + " kms away."
			else:
				proximity.text = "The Gate is " + str(nearest).pad_decimals(1) + " meters away."
		
func switch_scene(scene):
	GameManager.switch_scene(scene)
