extends Node2D

@onready var label = $Label

func _ready() -> void:
	# Create a sequence tween (happens one after another, not all at once)
	var tween = create_tween()
	
	# 1. Wait here doing nothing for 2.5 seconds
	tween.tween_interval(2.5)
	
	# 2. Fade out to invisible over the next 0.5 seconds (Total = 3 seconds)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	# 3. Delete the text node when the fading is done
	tween.tween_callback(queue_free)

# This function lets us set the text before it appears
func setup_text(new_text: String, color: Color = Color.WHITE):
	label.text = new_text
	label.modulate = color
