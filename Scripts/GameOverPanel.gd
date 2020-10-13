extends Node2D

var score = 0
onready var persistence = get_node("/root/Persistence")

func _ready():
	score = persistence.get_data()
	if score.size() == 0:
		score["initScore"] = 0
		persistence.save_data()
	pass 

func _process(delta):
	if global_vars.gameOver == true and self.visible == false:
		self.visible = true
		SoundManager.stop_bgm("Level1Music")
		SoundManager.play_se("GameOverSoundFX")
		if global_vars.score > score["initScore"]:
			score["initScore"] = global_vars.score
			persistence.save_data()
		if $anim.is_playing() == false:
			$anim.play("Move")
		$current_score.text = "Current Score: " + str(global_vars.score)
		$maximum_score.text = "Maximum Score: " + str(score["initScore"])

func _on_anim_animation_finished(anim_name):
	if anim_name == "Move":
		get_tree().paused = true
	pass # Replace with function body.


func _on_BacktoTitleScreen_pressed():
	get_tree().paused = false
	global_vars.gameOver = false
	global_vars.score = 0
	get_tree().change_scene("res://Scenes/Game/TitleScreen.tscn")
	pass # Replace with function body.
