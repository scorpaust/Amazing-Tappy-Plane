extends Area2D


func _ready():
	$sprite.frame = rand_range(-1, 3)
	pass 

func _process(delta):
	move_local_x(-300 * delta)

func _on_Star_body_entered(body):
	if body is RigidBody2D:
		global_vars.score += $sprite.frame + 1
		SoundManager.play_se("StarPickUpSoundFX")
		queue_free()
	pass # Replace with function body.
