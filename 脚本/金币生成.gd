extends Node2D

var 金币模块 := preload("res://场景/金币模块.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass




func _on_金币生成timer_timeout() -> void:
	var 金币 = 金币模块.instantiate()
	#var rng = RandomNumberGenerator.new()
	#rng.randomize()
	#金币.position.y = 191
	#金币.position.x = rng.randi_range(-250 , 760)
	var randint = randi_range(-250 , 760)
	金币.position = Vector2(randint , 191)
	add_child(金币)
