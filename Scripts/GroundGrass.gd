extends StaticBody2D

const SPEED = 410

var left = -1

func _ready():
	$sprite.animation = global_vars.style["Ground"]
	pass 

func _process(delta):
	move_local_x(left * delta * SPEED)
	
	if global_position.x <= -404:
		global_position.x = -404 + 808 * 2

func _on_detect_body_entered(body):
	if body is RigidBody2D and body.get_name() == "Plane":
		global_vars.gameOver = true
	pass # Replace with function body.
