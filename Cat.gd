extends KinematicBody2D

var velocity : Vector2

export var max_speed : int = 1000
export var gravity : float = 55
export var jump_force : = 1600
export var acceleration : int = 50
export var jump_buffer_time : int = 15
export var cayote_time : int = 15


var jump_buffer_counter : int = 0
var cayote_counter : int = 0

func _physics_process(delta):
	#More time for jump
	if is_on_floor():
		cayote_counter = cayote_time
	
	#Gravity
	if not is_on_floor():
		if cayote_counter > 0:
			cayote_counter -= 1
		
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000

	#Movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += acceleration
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= acceleration
		$Sprite.flip_h = true
	else:
		velocity.x = lerp(velocity.x,0,0.2)
	
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < -max_speed:
		velocity.x = -max_speed
	
	#Prevent Jump Delay
	if Input.is_action_pressed("ui_select"):
		jump_buffer_counter = jump_buffer_time
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	if jump_buffer_counter > 0 and cayote_counter > 0:
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
	
	#Long Jump
	if Input.is_action_just_released("ui_select"):
		if velocity.y < 0:
			velocity.y += 400
	velocity = move_and_slide(velocity, Vector2.UP)
