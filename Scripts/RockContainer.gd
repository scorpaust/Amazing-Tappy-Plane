extends Node2D

onready var rock = preload("res://Scenes/Rock/Rock.tscn")
onready var star = preload("res://Scenes/Star/Star.tscn")

func _ready():
	pass 

func _process(delta):
	if $generation_time.is_stopped():
		create_rock_and_star()
		$generation_time.start()

func create_rock_and_star():
	var new_rock = rock.instance()
	new_rock.global_position = Vector2(1000, rand_range(-68,90))
	add_child(new_rock) 
	
	var new_star = star.instance()
	new_star.global_position = Vector2(new_rock.global_position.x, new_rock.global_position.y + 250)
	add_child(new_star)