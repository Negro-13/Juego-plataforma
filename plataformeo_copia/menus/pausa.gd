extends CanvasLayer

func _physics_process(_delta):
		if Input.is_action_just_pressed("Pausa"):
			get_tree().paused = not get_tree().paused
			$ColorRect.visible = not $ColorRect.visible
			$VBoxContainer.visible = not $VBoxContainer.visible

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/menu.tscn")
