extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("solveed")
	print(get_parent())
	print(get_parent().get_parent())
	get_parent().get_parent().solved = true
