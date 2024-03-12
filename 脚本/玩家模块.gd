extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
const JUMP_VELOCITY = -400.0
var speed = 100.0
var speed_number = 1

enum {
	MOVE,
	SLIDE,
	BLOCK,
	ATTACK1,
	ATTACK2,
	ATTACK3,
	DEATH
}
var state = MOVE

var health = 100
var gold = 0
var combo = false
var can_jump = true

func _ready() -> void:
	point_light_2d.energy = 1

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state()
		SLIDE:
			slide_stste()
		BLOCK:
			block_state()
		ATTACK1:
			attack1_state()
		ATTACK2:
			attack2_state()
		ATTACK3:
			attack3_state()
		DEATH:
			death_state()
			
	if not is_on_floor():
		velocity.y += gravity * delta
	var should_jump = can_jump and is_on_floor()
	if Input.is_action_just_pressed("ui_accept") and should_jump:
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump")
	if velocity.y > 0:
		animation_player.play("fall")
	if health <= 0:
		health = 0
		animation_player.play("death")
		await animation_player.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://场景/开始菜单.tscn")
	move_and_slide()
	
func move_state():
	can_jump = true
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed * speed_number
		if velocity.y == 0:
			if speed_number == 1:
				animation_player.play("walk")
			if speed_number == 2:
				animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.y == 0:
			animation_player.play("idle")
	if not is_zero_approx(direction):
		animated_sprite_2d.flip_h = direction < 0
	if Input.is_action_pressed("run"):
		speed_number = 2
	else :
		speed_number = 1
	if Input.is_action_just_pressed("block"):
		state = BLOCK
	if Input.is_action_pressed("slide") and velocity.x != 0:
		if velocity.y == 0: 
			state = SLIDE
	if Input.is_action_pressed("attack"):
		if velocity.y == 0:
			state = ATTACK1
	
func block_state():
	can_jump = false
	velocity.x = 0
	animation_player.play("block")
	if Input.is_action_just_released("block"):
		state = MOVE
	
func slide_stste():
	can_jump = false
	animation_player.play("slide")
	await animation_player.animation_finished
	state = MOVE
	
func attack1_state():
	velocity.x = 0
	can_jump = false
	animation_player.play("attack1")
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2
	await animation_player.animation_finished
	state = MOVE
func death_state():
	pass
func combo1():
	combo = true
	await animation_player.animation_finished #用以动画播放期间 插入下一个动作
	combo = false
func attack2_state():
	velocity.x = 0
	can_jump = false
	animation_player.play("attack2")
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK3
	await animation_player.animation_finished
	state = MOVE
func attack3_state():
	velocity.x = 0
	can_jump = false
	animation_player.play("attack3")
	await animation_player.animation_finished
	state = MOVE
