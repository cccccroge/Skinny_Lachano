extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# path = res://dialogue/texts/*.csv

var fd : File
var textLabel : RichTextLabel
var sentences = {}#Variant
var nextCount = 0

# init只有初始化參數，還沒進入到 scene tree
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	textLabel = get_node("ColorRect/RichTextLabel")
	textLabel.bbcode_enabled = true;
	pass # Replace with function body.

func _enter_tree():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 讀對話檔案
func setDialogScript(path):
	fd = File.new()
	fd.open(path, _File.READ)
	
	while !fd.eof_reached():
		var csvLines = Array(fd.get_csv_line())
		sentences[sentences.size()] = csvLines
	
	fd.close()
	
	print("[Debug] \n" + sentences)
	
func nextSentence():
	
	textLabel.bbcode_text = sentences[nextCount]
	nextCount = nextCount + 1

func setSentenceIndex(index):

	textLabel.bbcode_text = sentences[index]
	nextCount = index

func getCurrentSentenceIndex():
	return nextCount


