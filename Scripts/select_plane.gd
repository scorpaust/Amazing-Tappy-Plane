extends NinePatchRect

var int_plane = 1

func _ready():
	pass

func _process(delta):
	$Image.texture = load("res://UI/Selector/Planes/Textures/plane" + str(int_plane) + ".png")
	if int_plane == 1:
		global_vars.style["ColorPlane"] = "Blue"
		$Label.text = "Blue Plane"
	if int_plane == 2:
		global_vars.style["ColorPlane"] = "Green"
		$Label.text = "Green Plane"
	if int_plane == 3:
		global_vars.style["ColorPlane"] = "Red"
		$Label.text = "Red Plane"
	if int_plane == 4:
		global_vars.style["ColorPlane"] = "Yellow"
		$Label.text = "Yellow Plane"

func _on_left_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	int_plane -= 1
	if int_plane <= 0:
		int_plane = 4
	pass # Replace with function body.


func _on_right_pressed():
	SoundManager.play_se("ClickPressedSoundFX")
	int_plane += 1
	if int_plane > 4:
		int_plane = 1
	pass # Replace with function body.


func _on_left_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.


func _on_right_mouse_entered():
	SoundManager.play_se("ClickHoverSoundFX")
	pass # Replace with function body.
