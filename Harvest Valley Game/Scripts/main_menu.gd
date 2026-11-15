extends Control

func _ready() -> void:
	# Makes sure your mouse is visible on the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_pressed() -> void:
	# Loads your actual game
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_exit_button_pressed() -> void:
	# Closes the game completely
	get_tree().quit()
