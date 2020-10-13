extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.add_background_sound("Level1Music")
	SoundManager.play_bgm("Level1Music")
	global_vars.isInGame = true
	pass # Replace with function body.

func _physics_process(delta):
	if !global_vars.gameOver and !SoundManager.is_bgm_playing("Level1Music"):
		SoundManager.play_bgm("Level1Music", 7.0)
	if global_vars.gameOver:
		global_vars.isInGame = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
