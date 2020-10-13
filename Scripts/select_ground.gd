extends NinePatchRect

var int_ground = 1

func _ready():
	pass

func _process(delta):
	$Image.texture = load("res://UI/Selector/Grounds/Textures/ground" + str(int_ground) + ".png")
	if int_ground == 1:
		global_vars.style["Ground"] = "Dirt"
		$Label.text = "Dirt Ground"
	if int_ground == 2:
		global_vars.style["Ground"] = "Grass"
		$Label.text = "Grass Ground"
	if int_ground == 3:
		global_vars.style["Ground"] = "Ice"
		$Label.text = "Ice Ground"
	if int_ground == 4:
		global_vars.style["Ground"] = "Rock"
		$Label.text = "Rock Ground"
	if int_ground == 5:
		global_vars.style["Ground"] = "Snow"
		$Label.text = "Snow Ground"

func _on_left_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	int_ground -= 1
	if int_ground <= 0:
		int_ground = 5
	pass # Replace with function body.


func _on_right_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	int_ground += 1
	if int_ground > 5:
		int_ground = 1
	pass # Replace with function body.

func _on_left_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.


func _on_right_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.
