extends Control

var sentences = []
var next_count = 0
var length
var key : String

onready var textLabel := $ColorRect/RichTextLabel

func _ready():
	TranslationServer.set_locale("en")
	sentences = tr(key).split("||")
	length = sentences.size()
	next_sentence() 
	
func next_sentence():
	if length == next_count:
		return queue_free()
	
	textLabel.text = sentences[next_count]
	next_count += 1

func _input(event):
	if event.is_action_type() and event.is_action_pressed("ui_accept"):
		next_sentence()
