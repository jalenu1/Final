extends KinematicBody2D

var velocity = Vector2()
export var direction = 1
export var detects_cliffs = true

func _ready():
	if direction == -1:
		$AnimatedSprite.flip_h = true
	$FloorCheck.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$FloorCheck.enabled = detects_cliffs

func _physics_process(delta):
	
	if is_on_wall() or not $FloorCheck.is_colliding() and detects_cliffs and is_on_floor():
		
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorCheck.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	
	velocity.y += 20
	
	velocity.x = 400 * direction
	
	move_and_slide(velocity, Vector2.UP)

