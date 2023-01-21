extends KinematicBody2D

enum States{AIR = 1, FLOOR, LADDER, WALL}
var state = States.AIR

var velocity = Vector2(0,0)
export var direction = 1
var last_wall_jump = 0
const SPEED = 3500
const RUN = 5000
const GRAVITY = 100
const JUMPFORCE = -3500
var is_attacking = false;

func _physics_process(delta):
	print(is_beside_wall())
	match state:
		States.AIR:
			if is_on_floor():
				last_wall_jump = 0
				state = States.FLOOR
				continue
			elif is_beside_wall():
				state = States.WALL
				continue
			if Input.is_action_pressed("ui_right") && is_attacking == false:
				velocity.x = lerp(velocity.x, SPEED,0.1) if velocity.x < SPEED else lerp(velocity.x, SPEED,0.04)
				$AnimatedSprite.flip_h = false
			elif Input.is_action_pressed("ui_left") && is_attacking == false:
				velocity.x = lerp(velocity.x, -SPEED,0.1) if velocity.x < SPEED else lerp(velocity.x, -SPEED,0.04)
				$AnimatedSprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x,0,0.2)
			set_direction()
			move_fall(false)
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			#Movement
			if Input.is_action_pressed("ui_right") && is_attacking == false:
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, RUN, 0.1)
					$AnimatedSprite.set_speed_scale(1.5)
					$AnimatedSprite.play("Walk")
				else:
					velocity.x = lerp(velocity.x, SPEED, 0.1)
					$AnimatedSprite.set_speed_scale(1.0)
				$AnimatedSprite.play("Walk")
				$AnimatedSprite.flip_h = false
			elif Input.is_action_pressed("ui_left") && is_attacking == false:
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, -RUN, 0.1)
					$AnimatedSprite.set_speed_scale(1.5)
				else:
					velocity.x = lerp(velocity.x, -SPEED, 0.1)
					$AnimatedSprite.set_speed_scale(1.0)
				$AnimatedSprite.play("Walk")
				$AnimatedSprite.flip_h = true
			else:
				if is_attacking == false:
					$AnimatedSprite.play("Idle")
					velocity.x = lerp(velocity.x,0,0.2)

			if Input.is_action_just_pressed("jump") and is_on_floor():
				$AnimatedSprite.play("Jump")
				velocity.y = JUMPFORCE
				state = States.AIR
			
	
			if Input.is_action_just_pressed("jump") and is_on_wall():
				$AnimatedSprite.play("Jump")
				velocity.y = JUMPFORCE
				state = States.WALL
			set_direction()
			move_fall(false)
		
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
				last_wall_jump = 0
				continue
			elif not is_beside_wall():
				state = States.AIR
				$AnimatedSprite.play("Idle")
				continue
			$AnimatedSprite.play("Walljump")
			
			if direction != last_wall_jump and Input.is_action_pressed("jump") and (Input.is_action_pressed("ui_left") and direction == 1) or (Input.is_action_pressed("ui_right") and direction == -1):
				last_wall_jump = direction
				velocity.x = 600 * -direction
				velocity.y = JUMPFORCE * 15
				state = States.AIR
				
			move_fall(true)

func set_direction():
	direction = 1 if not $AnimatedSprite.flip_h else -1
	$WallCheck.rotation_degrees = 90 * -direction
	
	
func is_beside_wall():
	return $WallCheck.is_colliding() 

func move_fall(slowfall: bool):
		velocity.y = velocity.y + GRAVITY
		if slowfall:
			velocity.y = clamp(velocity.y, JUMPFORCE, 700)
		velocity = move_and_slide(velocity, Vector2.UP)
