extends CharacterBody2D

@export var move_speed: float
@export var jump_speed: float
var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

func  _physics_process(delta):
	update_animations()
	if GameManager.is_dialogue_active:
		return
	move_x()
	jump(delta)
	flip()
	move_and_slide()
	
func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
		return
	
	if velocity.x:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("default")

func jump(delta):
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = -jump_speed
	if not is_on_floor():
		velocity.y += gravity * delta
	
func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right
	
	
func move_x():
	var input_axis = Input.get_axis("izquierda","derecha")
	velocity.x = input_axis * move_speed
	
