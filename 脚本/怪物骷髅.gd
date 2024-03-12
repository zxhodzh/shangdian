extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var 玩家模块: CharacterBody2D = $"../../玩家模块"
#@onready var 玩家模块: CharacterBody2D = $"玩家模块"

var speed := 100.0
var chase = false
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.ZERO
var alive = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	direction = (玩家模块.position - position).normalized()
	if alive:
		if chase == true:
			velocity.x = direction.x * speed
			animated_sprite_2d.play("run")
		else:
			velocity.x = 0
			animated_sprite_2d.play("idle")
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	move_and_slide()
	


	
func _on_追逐area_2d_body_entered(body: Node2D) -> void:
	if body.name == "玩家模块":
		chase = true
func _on_追逐area_2d_body_exited(body: Node2D) -> void:
	if body.name == "玩家模块":
		chase = false
	

func _on_被撞area_2d_body_entered(body: Node2D) -> void:
	if body.name == "玩家模块":
		body.velocity.y -= 10
		death()
func death():
	alive = false
	animated_sprite_2d.play("death")
	$CollisionShape2D.set_deferred("disabled", true)
	$"撞人Area2D/CollisionShape2D".set_deferred("disabled", true)
	await animated_sprite_2d.animation_finished
	queue_free()



func _on_撞人area_2d_body_entered(body: Node2D) -> void:
	if body.name == "玩家模块":
		if alive:
			body.health -= 10
		death()
