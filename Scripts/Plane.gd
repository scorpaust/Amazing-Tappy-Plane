extends RigidBody2D


func _ready():
	$sprite.animation = global_vars.style["ColorPlane"]
	pass

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_up"):
		_move()

func _move():
	linear_velocity = Vector2(0, - 240)

func _on_Retry_pressed():
	global_vars.gameOver = false
	global_vars.score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.
