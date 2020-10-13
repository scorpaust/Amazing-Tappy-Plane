extends ParallaxLayer

var speed = -300

func _ready():
	pass

func _process(delta):
	get_parent().scroll_offset.x += speed * delta