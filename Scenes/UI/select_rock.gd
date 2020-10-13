extends NinePatchRect

var int_rock = 1

func _ready():
	pass

func _process(delta):
	$Image.texture = load("res://UI/Selector/Rocks/Textures/rock" + str(int_rock) + ".png")
	if int_rock == 1:
		global_vars.style["Rock"] = "Rock"
		$Label.text = "Rock"
	if int_rock == 2:
		global_vars.style["Rock"] = "Grass"
		$Label.text = "Grass Rock"
	if int_rock == 3:
		global_vars.style["Rock"] = "Ice"
		$Label.text = "Ice Rock"
	if int_rock == 4:
		global_vars.style["Rock"] = "Snow"
		$Label.text = "Snow Rock"

func _on_left_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	int_rock -= 1
	if int_rock <= 0:
		int_rock = 4
	pass # Replace with function body.


func _on_right_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	int_rock += 1
	if int_rock > 4:
		int_rock = 1
	pass # Replace with function body.


func _on_left_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.


func _on_right_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.
