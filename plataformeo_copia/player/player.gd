extends CharacterBody2D

@export var lives=3
@export var move_speed=100
@export var jump_speed=300

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_up = $AnimatedSprite2D/up
@onready var ray_down = $AnimatedSprite2D/down

var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var if_dash=false
var can_dash=true
var if_run=false
var direction=1
var coyote_jump=false
var dobleJump=true
var inmunity=false

func  _physics_process(delta):
	update_animations()
	if GameManager.is_dialogue_active:
		return
	move_x()
	jump(delta)
	flip()
	dash()
	move_and_slide()
	
func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
		return
	
	if velocity.x:
		if move_speed==100:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("default")

func jump(delta):
	if Input.is_action_just_pressed("saltar") and (is_on_floor() or coyote_jump or dobleJump):
		if not is_on_floor() and not coyote_jump:
			dobleJump=false
			velocity.y =-jump_speed
		velocity.y = -jump_speed
		
	if not is_on_floor():
		if coyote_jump:
			coyote_timer()
		else:
			velocity.y += gravity * delta
	else:
		can_dash=true
		dobleJump=true
		coyote_jump=true
	if Input.is_action_just_released("saltar") and velocity.y<=0:
		velocity.y=-jump_speed/2
func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func move_x():
	var input_axis = Input.get_axis("izquierda","derecha")

	if if_dash:
		
		move_speed*=1.6
		velocity.x = direction * float(move_speed)
		if sign(input_axis)!=sign(velocity.x) and input_axis:
			if_dash=false
			move_speed=100
			velocity.x= move_toward(velocity.x, input_axis * float(move_speed), move_speed/5)

	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * float(move_speed), move_speed/10)
		direction=input_axis
	elif not if_dash:
		velocity.x=move_toward(velocity.x, 0, move_speed/10)
		move_speed=100

func dash():
	if Input.is_action_just_pressed("dash") and not if_dash and not if_run and can_dash:
		velocity.x = direction * move_speed
		delay_dash()
		if_dash=true
		if_run=true
		can_dash=false
		velocity.y=0
		
	if Input.is_action_just_released("dash"):
		if_run=false
		move_speed=100

		
func delay_dash():
	await get_tree().create_timer(0.09).timeout
	if_dash=false
	velocity.x/=7
	if if_run:
		move_speed=300
	else:
		move_speed=100

func coyote_timer():
	await get_tree().create_timer(0.12).timeout
	coyote_jump=false

func inmunity_timer():
	await get_tree().create_timer(1).timeout
	inmunity=false

func _on_hit_box_area_entered(area):
	print(lives)
	var enemy=area.get_parent()
	if not inmunity:
		lives-=1
		velocity=Vector2(sign(enemy.position.x-position.x)*-150,sign(enemy.position.y-position.y)*250)
		inmunity=true
		inmunity_timer()
	if area.get_collision_layer_value(5) or lives==0:
		get_tree().reload_current_scene()
