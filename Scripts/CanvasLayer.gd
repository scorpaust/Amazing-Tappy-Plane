extends CanvasLayer


func _ready():
	pass

func _process(delta):
	$score.text = "Score = " + str(global_vars.score)
	pass

func _on_pause_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	if get_tree().paused == false:
		get_tree().paused = true
	else:
		get_tree().paused = false
	pass # Replace with function body.


func _on_selector_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	get_tree().change_scene("res://Scenes/UI/Selector.tscn")
	pass # Replace with function body.


func _on_pause_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.


func _on_selector_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	SoundManager.stop_bgm("Level1Music")
	SoundManager.play_bgm("MenuMusic")
	pass # Replace with function body.
