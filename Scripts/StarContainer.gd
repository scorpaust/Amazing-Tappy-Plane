extends Node2D

onready var star = preload("res://Scenes/Star/Star.tscn")

onready var rock_container = get_parent().get_node("RockContainer")

var done = false

func _ready():
	pass 

func _process(delta):
	if $generation_time.is_stopped():
		create_star()
		$generation_time.start()

func create_star():
	for rock in rock_container.get_children():	
		var new_star = star.instance()	
		if rock.name != "generation_time" and !new_star.done:
			new_star.global_position = Vector2(rock.global_position.x, rock.global_position.y + 250)
			new_star.done = true
			add_child(new_star) 
