
extends KinematicBody2D

var ball_scene = preload("res://player/ball.tscn")
var gun_flash_scene = preload("res://player/gun_flash.tscn")
var input_states = preload("res://scripts/input_states.gd")

export(float) var speed = 300
export(int) var life = 200
export(int) var weapon = 45

var btn_right
var btn_left
var btn_down
var btn_up
var btn_shoot = input_states.new("btn_shoot")

var is_moving = false
var is_shooting = false
var is_alive = true

var dir = Vector2()


func _ready():
	set_z(1)
	set_fixed_process(true)

func _fixed_process(delta):
	btn_right = Input.is_action_pressed("btn_right")
	btn_left = Input.is_action_pressed("btn_left")
	btn_down = Input.is_action_pressed("btn_down")
	btn_up = Input.is_action_pressed("btn_up")
	
	if is_alive:
		if life <= 0:
			life = 0
			is_alive = false
		else:
			is_alive = true
			
		if btn_right or btn_left or btn_down or btn_up:
			is_moving = true
		else:
			is_moving = false
		
		if btn_shoot.check() == 1:
			is_shooting = true
		else:
			is_shooting = false
		
		if btn_right and not btn_left:
			dir.x = 1
		elif btn_left:
			dir.x = -1
		else:
			dir.x = 0
			
		if btn_down and not btn_up:
			dir.y = 1
		elif btn_up and not btn_down:
			dir.y = -1
		else:
			dir.y = 0
		
		if is_moving and not is_shooting and is_alive:
			get_node("sprite").play("walk")
		elif is_shooting and weapon > 0:
			weapon -= 1
			var ball = ball_scene.instance()
			var gun_flash = gun_flash_scene.instance()
			ball.set_direction(get_global_mouse_pos() - get_pos())
			ball.set_pos(get_node("gun").get_global_pos())
			ball.set_rot(get_rot())
			get_node("gun").add_child(gun_flash)
			ball.set_scale(Vector2(0.1,0.1))
			get_parent().add_child(ball)
		elif not is_alive:
			get_node("sprite").play("die")
		else:
			get_node("sprite").play("idle")
			
		
		move(dir * delta * speed)
		set_rot(get_pos().angle_to_point(get_global_mouse_pos()))
	



