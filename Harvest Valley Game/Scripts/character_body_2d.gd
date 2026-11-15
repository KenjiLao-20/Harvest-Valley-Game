extends CharacterBody2D

const FloatingTextScene = preload("res://Scenes/floating_text.tscn")

var speed = 50.0
var facing_direction = "down" 
var current_zone = null 
var is_doing_action = false 
var current_shop = null 
var has_shown_100_coins = false 

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# --- WIN CONDITION CHECK WITH 5-SECOND DELAY ---
	if Global.coins >= 100 and not has_shown_100_coins:
		has_shown_100_coins = true
		is_doing_action = true # Freeze the player so they can't move during the wait
		
		# Show a message so the player knows what's happening
		spawn_floating_text("You Got 100 Coins! You Win!", Color.BLACK) # Changed to Black
		
		# Wait for exactly 5 seconds
		await get_tree().create_timer(5.0).timeout
		
		# NOW load the win screen
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		return 

	if is_doing_action:
		velocity = Vector2.ZERO
		move_and_slide()
		return 

	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		facing_direction = "right"
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		facing_direction = "left"
	elif Input.is_action_pressed("ui_down"):
		velocity.y = speed
		facing_direction = "down"
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -speed
		facing_direction = "up"
		
	move_and_slide()
	
	if velocity != Vector2.ZERO:
		animated_sprite.play("walk_" + facing_direction)
	else:
		animated_sprite.play("idle_" + facing_direction)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_1:
			Global.plantselected = 1
			print("Equipped Carrot Seeds")
		elif event.keycode == KEY_2:
			Global.plantselected = 2
			print("Equipped Onion Seeds")
		elif event.keycode == KEY_G and current_shop != null and not is_doing_action:
			current_shop.sell_crops(self) 
			
		# --- CHEAT CODE FOR TESTING (PRESS P) ---
		elif event.keycode == KEY_P:
			Global.coins += 100
			print("CHEAT ACTIVATED: +100 Coins! Total: ", Global.coins)
		# ----------------------------------------

	# --- FARMING ACTIONS WITH ERROR CHECKS ---
	if current_zone != null and not is_doing_action:
		
		if Input.is_action_just_pressed("interact_plant"):
			if Global.plantselected == 1 and Global.carrot_seeds <= 0:
				spawn_floating_text("I Have No Seeds", Color.BLACK) # Changed to Black
			elif Global.plantselected == 2 and Global.onion_seeds <= 0:
				spawn_floating_text("I Have No Seeds", Color.BLACK)
			elif current_zone.current_state != current_zone.State.EMPTY:
				spawn_floating_text("Plot is already in use", Color.BLACK)
			else:
				do_zone_action("planting", "plant")
				
		elif Input.is_action_just_pressed("interact_water"):
			if current_zone.current_state == current_zone.State.EMPTY:
				spawn_floating_text("No Plant to Water", Color.BLACK)
			elif current_zone.current_state == current_zone.State.WATERED or current_zone.current_state == current_zone.State.GROWN:
				spawn_floating_text("Already Watered", Color.BLACK)
			else:
				do_zone_action("watering", "water")
				
		elif Input.is_action_just_pressed("interact_harvest"):
			if current_zone.current_state == current_zone.State.EMPTY:
				spawn_floating_text("No Plant to Harvest", Color.BLACK)
			elif current_zone.current_state == current_zone.State.PLANTED or current_zone.current_state == current_zone.State.WATERED:
				spawn_floating_text("Plant isn't Fully Grown yet", Color.BLACK)
			else:
				do_zone_action("harvesting", "harvest")

func do_zone_action(anim_name: String, action_type: String):
	is_doing_action = true
	animated_sprite.play(anim_name)
	
	if action_type == "plant":
		spawn_floating_text("Planting Seeds...")
		$PlantSound.play() 
	elif action_type == "water":
		spawn_floating_text("Watering Crops...")
		$WaterSound.play() 
	elif action_type == "harvest":
		spawn_floating_text("Harvesting Crops...")
		$HarvestSound.play() 
	
	await get_tree().create_timer(4.0).timeout
	
	if current_zone != null:
		if action_type == "plant":
			current_zone.attempt_plant()
		elif action_type == "water":
			current_zone.attempt_water()
		elif action_type == "harvest":
			current_zone.attempt_harvest()
			$EarnSound.play() 
		
	is_doing_action = false

# Changed default color to black here as well!
func spawn_floating_text(text: String, text_color: Color = Color.BLACK):
	var text_instance = FloatingTextScene.instantiate()
	get_parent().add_child(text_instance) 
	text_instance.global_position = global_position + Vector2(-25, -35) 
	text_instance.setup_text(text, text_color)
