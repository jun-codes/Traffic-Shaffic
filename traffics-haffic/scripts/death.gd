extends Node2D




func _on_btm_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")



func _on_restart_level_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
