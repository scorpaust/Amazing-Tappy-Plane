extends Node

func _ready():
	SoundManager.add_background_sound("MenuMusic")
	SoundManager.play_bgm("MenuMusic")
	pass 

func _process(delta):
	if !SoundManager.is_bgm_playing("MenuMusic"):
		SoundManager.play_bgm("MenuMusic", 7.0)

func _on_Selection_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	get_tree().change_scene("res://Scenes/UI/Selector.tscn")
	pass # Replace with function body.


func _on_Play_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	SoundManager.stop_bgm("MenuMusic")
	global_vars.score = 0
	get_tree().change_scene("res://Scenes/Level/Level1.tscn")
	pass # Replace with function body.


func _on_Selection_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.


func _on_Play_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.
