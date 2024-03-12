extends Node2D


@onready var 场景光照: DirectionalLight2D = $"光照模块/场景光照"
@onready var day_label = $"用户界面"/DAYLabel
@onready var 播放器 = $"用户界面"/AnimationPlayer
@onready var 点光源: PointLight2D = $"光照模块/点光源"
@onready var 点光源2: PointLight2D = $"光照模块/点光源2"
@onready var 点光源3: PointLight2D = $"玩家模块"/PointLight2D



enum {
	
	DAY,
	NIGHT
}

var state = DAY
var day_count : int


func _ready() -> void:
	场景光照.enabled = true
	点光源.energy = 2
	点光源2.energy = 2
	点光源3.energy = 1.2
	day_count = 0
	set_day_text()
	
	
func day_state():
	var tween = get_tree().create_tween()
	tween.tween_property(场景光照 , "energy" , 0.1 , 6)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(点光源 , "energy" , 0 , 6)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(点光源2 , "energy" , 0 , 6)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(点光源3 , "energy" , 0 , 6)
	
func night_state():
	var tween = get_tree().create_tween()
	tween.tween_property(场景光照 , "energy" , 0.8 , 6)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(点光源 , "energy" , 2 , 6)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(点光源2 , "energy" , 2 , 6)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(点光源3 , "energy" , 1.2 , 6)



	



func _on_日夜timer_timeout() -> void:
	match state:
		DAY:
			day_state()
		NIGHT:
			night_state()
	if state < 1:
		state += 1
		day_count += 1
		set_day_text()
		
	else:
		state = DAY
		
func set_day_text():
	day_label.text = "DAY:" + str(day_count)
	day_in_out()
	
func day_in_out():
	播放器.play("day_in")
	await get_tree().create_timer(3).timeout
	播放器.play("day_out")
