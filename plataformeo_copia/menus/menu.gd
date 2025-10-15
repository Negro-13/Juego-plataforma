extends CanvasLayer


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://mapas/mundo.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file('res://menus/opciones.tscn')


func _on_exit_pressed() -> void:
	get_tree().quit() 
