extends KinematicBody2D

signal health_updated(health)
signal killed()


var velocity : Vector2

export var max_speed : int = 4800
export var gravity : float = 640
export var jump_force : = 12800
export var acceleration : int = 1600
export var jump_buffer_time : int = 25
export var cayote_time : int = 25
var is_attacking = false;


export (float) var max_health = 100
#onready var health = max_health setget _set_health
#onready var invulnerability_timer = $InvulnerabilityTimer
#onready var effects_animation = $EffectsAnimation

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
	if Input.is_action_pressed("ui_right") && is_attacking == false:
		velocity.x += acceleration
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left") && is_attacking == false:
		velocity.x -= acceleration
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.flip_h = true
	else:
		if is_attacking == false:
			$AnimatedSprite.play("Idle")
			velocity.x = lerp(velocity.x,0,0.2)
			
		
			
	
	if Input.is_action_just_pressed("Attack"):
		$AnimatedSprite.play("Attack")
		is_attacking = true
		$AnimatedSprite/CatAttack/CollisionShape2D.disabled = false;
	
	
	
	
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < -max_speed:
		velocity.x = -max_speed
	

	
	#Jump Delay
	if Input.is_action_pressed("jump"):
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

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attack":
		$AnimatedSprite/CatAttack/CollisionShape2D.disabled = true;
		is_attacking = false


#func damage(amount):
#	if invulnerability_timer.is_stopped():
#		invulnerability_timer.start()
#		_set_health(health - amount)
#		effects_animation.play("Damage")
#		effects_animation.queue("Immune")

#func kill():
#	pass

#func _set_health(value):
#	var prev_health = health
#	health = clamp(value, 0, max_health)
#	if health != prev_health:
#		emit_signal("health_updated", health)
#		if health == 0:
#			kill()
#			emit_signal("Killed")
			
			
			


func _on_FallBarrier_body_entered(body):
	get_tree().change_scene("res://Map.tscn")



#func _on_InvulnerabilityTimer_timeout():
#	effects_animation.play("Idle")


func bounce():
	velocity.y = jump_force * 0.7

func ouch(var enemyposx):
	$AnimatedSprite.play("Damage")
	velocity.y = jump_force * 0.5
	
	if position.x < enemyposx:
		velocity.x = -800
	elif position.x > enemyposx:
		velocity.x = 800
	
	Input.action_release("ui_left")
	Input.action_release("ui_left")
	
	$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://Map.tscn")



