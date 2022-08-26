extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

export(Vector2) var direction = Vector2(1, 0) setget set_direction, get_direction
export(float) var speed = 15000 setget set_speed, get_speed
export(int) var degat = 3

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	set_linear_velocity(direction.normalized() * delta * speed)

func set_direction(value):
	direction = value
	
func get_direction():
	return direction

func set_speed(value):
	speed = value

func get_speed():
	return speed

func _on_ball_body_enter( body ):

	if body.get_name() != "player":
		if body.is_in_group("enemies"):
			if body.is_alive:
				body.life -= degat
		queue_free()
