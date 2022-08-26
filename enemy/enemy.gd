
extends KinematicBody2D

export(NodePath) var target_path = null
export(NodePath) var navigation_path = null
export(float) var speed = 100
export(int) var life = 10
export(int) var degat = 1
export(float) var seen_distance = 200000
export(float) var target_around_distance = 400000

var target
var navigation
var points = []
var target_around = false
var me_moving = false
var seen_target = false
var is_alive = true
var dir_target_me
var distance_target_me
var raycast
var nb = 0

func _ready():
	set_z(1)
	target = get_node(target_path)
	navigation = get_node(navigation_path)
	raycast = get_node("ray")

	add_to_group("enemies")
	for n in get_tree().get_nodes_in_group("enemies"):
		raycast.add_exception(n)
	
	set_fixed_process(true)

func _fixed_process(delta):
	if is_alive and target.is_alive:
		
		distance_target_me = get_pos().distance_squared_to(target.get_pos())
		target_around = false
		me_moving = false
		seen_target = false
	
		if raycast.is_colliding():
			if raycast.get_collider() == target:
				target.life -= degat
		
		if life <= 0:
			is_alive = false
		
			
		if  distance_target_me <= target_around_distance:
			target_around = true
		else:
			target_around = false
			
		if distance_target_me <= seen_distance:
			seen_target = true
		else:
			seen_target = false
			
		if seen_target and is_alive:
			me_moving = true
			set_rot(get_pos().angle_to_point(target.get_pos()) + deg2rad(180))
		else:
			me_moving = false
			
		if seen_target:
			points = navigation.get_simple_path(get_pos(), target.get_pos())
			
		if me_moving and is_alive and points.size() >1:
			var distance = points[1] - get_pos()
			var dir_target_me = distance.normalized()
			move(dir_target_me * delta * speed)
		else:
			move(Vector2(0,0))
		
		if me_moving:
			get_node("sprite").play("walk")
		elif not is_alive:
			get_node("sprite").play("die")
			get_node("collision").set_trigger(true)
			set_z(0)
			if is_in_group("enemies"):
				remove_from_group("enemies")
			set_fixed_process(false)
		else:
			get_node("sprite").play("idle")
	elif is_alive and not target.is_alive:
			get_node("sprite").play("idle")

	
	
func set_target(value):
	target_path = value
	

func get_target():
	return target_path
