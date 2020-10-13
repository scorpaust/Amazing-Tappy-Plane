extends Node

func _ready():
	SoundManager.stop_bgm("Level1Music")
	SoundManager.play_bgm("MenuMusic")
	if global_vars.isInGame:
		$Button.text = "<< RESUME PLAY"
	else:
		$Button.text = "<< BACK TO TITLE SCREEN"
	pass 

func _on_Button_pressed():
	if global_vars.isInGame:
		get_tree().change_scene("res://Scenes/Level/Level1.tscn")
	else:
		get_tree().change_scene("res://Scenes/Game/TitleScreen.tscn")
	pass # Replace with function body.
