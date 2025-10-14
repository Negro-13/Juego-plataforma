extends Area2D
const DIALOGO_1 = preload("res://dialogos/dialogo 1.dialogue")
var is_player_close = false


func _ready():
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(delta):
	if is_player_close and Input.is_action_just_pressed("talk") and not GameManager.is_dialogue_active:
		print('Iniciando dialogo')
		DialogueManager.show_dialogue_balloon(DIALOGO_1, 'start')
func _on_area_entered(area):
	is_player_close = true
	
func _on_area_exited(area):
	is_player_close = false
	
func _on_dialogue_started(dialogue):
	GameManager.is_dialogue_active = true
	
	
func _on_dialogue_ended(dialogue):
	await  get_tree().create_timer(0.2).timeout
	GameManager.is_dialogue_active = false
