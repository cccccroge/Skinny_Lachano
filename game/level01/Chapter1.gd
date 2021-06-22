extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var area2d   = $TileMap_structure/Area2D
var x 

# Called when the node enters the scene tree for the first time.
func _ready():
	area2d.connect("body_entered", self, "create_dialogue")
	
	pass # Replace with function body.
 
func create_dialogue(body):
	print(body.name)
	
	if body.name != "Lachano":
		return
		
	x = load("res://ui/dialogue/dialogue.tscn").instance()
	x.key = "ASK"
	self.add_child(x)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
