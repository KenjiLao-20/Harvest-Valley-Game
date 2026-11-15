extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Reset stats
	Global.coins = 0
	Global.numofcarrots = 0
	Global.numofonions = 0
	Global.carrot_seeds = 0
	Global.onion_seeds = 0
	
	# Safely connect buttons without causing "already connected" errors
	var replay_btn = find_child("ReplayButton")
	var exit_btn = find_child("ExitButton")
	
	if replay_btn and not replay_btn.pressed.is_connected(_on_replay_button_pressed):
		replay_btn.pressed.connect(_on_replay_button_pressed)
		
	if exit_btn and not exit_btn.pressed.is_connected(_on_exit_button_pressed):
		exit_btn.pressed.connect(_on_exit_button_pressed)
	
	print("Win Screen loaded and stats reset!")

func _on_replay_button_pressed() -> void:
	print("Replay button was clicked! Trying to load world...")
	
	var error = get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
	if error != OK:
		print("ERROR: Could not load the game. Check the file path!")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
