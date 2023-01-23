extends Node2D

onready var FINISHLINE := $Area2D
onready var player := $Player
func finish_game() -> void:
	set_process(false)
	player.set_physics_process(false)
	$Player/AnimatedSprite.play("")
	$CanvasLayer/Label.visible = true;
func _on_Area2D_body_entered(body):
	finish_game()
