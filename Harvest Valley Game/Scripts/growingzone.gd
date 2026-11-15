extends StaticBody2D

enum State { EMPTY, PLANTED, WATERED, GROWN }

var current_state = State.EMPTY
var current_plant = 0 

func _ready() -> void:
	$plant.visible = false 
	# Connect the timers

# --- THIS TELLS THE PLAYER THEY ARE ON THE ZONE ---
func _on_area_2d_body_entered(body):
	if body.name == "CharacterBody2D":
		body.current_zone = self

func _on_area_2d_body_exited(body):
	if body.name == "CharacterBody2D":
		body.current_zone = null
# --------------------------------------------------

func attempt_plant():
	if current_state != State.EMPTY: return
	
	if Global.plantselected == 1 and Global.carrot_seeds > 0:
		current_plant = 1
		current_state = State.PLANTED
		$plant.visible = true
		$plant.play("carrotgrowing")
		$plant.frame = 0 
		print("Planted carrot.")
	elif Global.plantselected == 2 and Global.onion_seeds > 0:
		current_plant = 2
		current_state = State.PLANTED
		$plant.visible = true
		$plant.play("oniongrowing")
		$plant.frame = 0
		print("Planted onion.")
	else:
		print("No seeds in inventory!")

func attempt_water():
	if current_state != State.PLANTED: return
	
	current_state = State.WATERED
	print("Watered the plant! Starting timer...") 
	
	if current_plant == 1:
		$carrotgrowtimer.start()
	elif current_plant == 2:
		$oniongrowtimer.start()

func attempt_harvest():
	if current_state != State.GROWN: return
	
	if current_plant == 1:
		Global.numofcarrots += 1
		print("Harvested Carrot! Total: ", Global.numofcarrots)
	elif current_plant == 2:
		Global.numofonions += 1
		print("Harvested Onion! Total: ", Global.numofonions)
		
	current_state = State.EMPTY
	current_plant = 0
	$plant.visible = false
	$carrotgrowtimer.stop()
	$oniongrowtimer.stop()

func _on_carrotgrowtimer_timeout() -> void:
	if $plant.frame == 0:
		$plant.frame = 1
		$carrotgrowtimer.start()
	elif $plant.frame == 1:
		$plant.frame = 2
		current_state = State.GROWN
		print("Carrot is fully grown!")

func _on_oniongrowtimer_timeout() -> void:
	if $plant.frame == 0:
		$plant.frame = 1
		$oniongrowtimer.start()
	elif $plant.frame == 1:
		$plant.frame = 2
		current_state = State.GROWN
		print("Onion is fully grown!")
