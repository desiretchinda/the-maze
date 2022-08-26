
extends Node2D


func _ready():
	remove_from_group("enemies")
	set_fixed_process(true)

func _fixed_process(delta):
	get_node("gui/ParallaxBackground/TextureFrame/rest_life").set_text(str(get_node("player").life))
	get_node("gui/ParallaxBackground/TextureFrame/rest_arme").set_text(str(get_node("player").weapon))