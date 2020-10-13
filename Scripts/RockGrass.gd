extends StaticBody2D

export (int) var speed = -300

func _ready():
	$rock_down.animation = global_vars.style["Rock"]
	$rock_up.animation = global_vars.style["Rock"]
	pass # Replace with function body.

func _process(delta):
	move_local_x(speed * delta)
	if global_position.x <= -404:
		queue_free()

func _on_area_body_entered(body):
	if body is RigidBody2D and body.get_name() == "Plane":
		global_vars.gameOver == true
	pass # Replace with function body.
