extends Node2D

func _physics_process(_delta: float) -> void:
	$carrottext.text = ("= " + str(Global.numofcarrots))
	$oniontext.text = ("= " + str(Global.numofonions))
	$cointext.text = ("= " + str(Global.coins))
