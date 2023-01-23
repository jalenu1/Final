extends Area2D





#func _on_SpikeTrap_area_entered(_area):
#	get_tree().change_scene("res://GameOver.tscn")


func _on_SpikeTrap_body_entered(body):
	get_tree().change_scene("res://GameOver.tscn")
