extends Area2D

func _ready() -> void:
	print(">>> SEEDPACK IS READY AND ALIVE <<<")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print(">>> SOMETHING TOUCHED THE SEEDPACK: ", body.name, " <<<")
	
	if body.name == "CharacterBody2D":
		Global.carrot_seeds += 1
		print("Picked up a seed! Total: ", Global.carrot_seeds)
		
		# Spawn the floating text above the player
		body.spawn_floating_text("Carrot Seeds Picked Up", Color.BLACK) # Changed to Black
		
		# Play the pickup sound on the player
		body.get_node("PickupSound").play() 
		
		queue_free()
