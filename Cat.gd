extends KinematicBody2D

var velocity : Vector2

export var max_speed : int = 4800
export var gravity : float = 640
export var jump_force : = 12800
export var acceleration : int = 1600
export var jump_buffer_time : int = 25
export var cayote_time : int = 25


var jump_buffer_counter : int = 0
var cayote_counter : int = 0

func _physics_process(delta):
	#More time for jump
	if is_on_floor():
		cayote_counter = cayote_time
	
	#Gravity
	if not is_on_floor():
		$AnimatedSprite.play("Jump")
		if cayote_counter > 0:
			cayote_counter -= 1
		
		velocity.y += gravity
		if velocity.y > 10240:
			velocity.y = 10240

	#Movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += acceleration
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= acceleration
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("Idle")
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
			velocity.y += 1200
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_FallBarrier_body_entered(body):
	get_tree().change_scene("res://Map.tscn")
