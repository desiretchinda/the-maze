
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	
	if not get_node("anim").is_playing():
		queue_free()


