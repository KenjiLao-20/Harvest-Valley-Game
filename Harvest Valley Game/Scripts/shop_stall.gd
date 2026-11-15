extends Area2D

const FloatingTextScene = preload("res://Scenes/floating_text.tscn")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		body.current_shop = self
		print("Player is near the shop. Press G to sell.")

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		body.current_shop = null
		print("Player left the shop.")

func sell_crops(player): 
	var total_items = Global.numofcarrots + Global.numofonions
	
	if total_items > 0:
		var money_earned = total_items * 10
		Global.coins += money_earned
		print("Sold ", total_items, " crops for ", money_earned, " coins!")
		
		# Spawn text above the girl
		var text_instance = FloatingTextScene.instantiate()
		get_parent().add_child(text_instance)
		text_instance.global_position = global_position + Vector2(-25, -35)
		text_instance.setup_text("Here's Your Coins!", Color.BLACK) # Changed to Black
		
		# Play the earning sound on the player!
		player.get_node("EarnSound").play() 
		
		Global.numofcarrots = 0
		Global.numofonions = 0
	else:
		# Spawn text above the girl
		var text_instance = FloatingTextScene.instantiate()
		get_parent().add_child(text_instance)
		text_instance.global_position = global_position + Vector2(-25, -35)
		text_instance.setup_text("You have no Crops to Sell!", Color.BLACK) # Changed to Black
