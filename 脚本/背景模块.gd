extends ParallaxBackground

var speed := 33

func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	scroll_offset.x -= speed * delta
