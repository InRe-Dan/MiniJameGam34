class_name ApprovalRating extends HBoxContainer

@export var speed : float = 1.0

@onready var one: TextureRect = $"1"
@onready var two: TextureRect = $"2"
@onready var three: TextureRect = $"3"
@onready var four: TextureRect = $"4"
@onready var five: TextureRect = $"5"

var target : float = 0:
	set(v):
		target = v
		if v > 0.9: (five.texture as AtlasTexture).region = Rect2i(0, 0, 18, 18)
		elif v > 0.8: (five.texture as AtlasTexture).region = Rect2i(20, 0, 18, 18)
		else: (five.texture as AtlasTexture).region = Rect2i(40, 0, 18, 18)
		if v > 0.7: (four.texture as AtlasTexture).region = Rect2i(0, 0, 18, 18)
		elif v > 0.6: (four.texture as AtlasTexture).region = Rect2i(20, 0, 18, 18)
		else: (four.texture as AtlasTexture).region = Rect2i(40, 0, 18, 18)
		if v > 0.5: (three.texture as AtlasTexture).region = Rect2i(0, 0, 18, 18)
		elif v > 0.4: (three.texture as AtlasTexture).region = Rect2i(20, 0, 18, 18)
		else: (three.texture as AtlasTexture).region = Rect2i(40, 0, 18, 18)
		if v > 0.3: (two.texture as AtlasTexture).region = Rect2i(0, 0, 18, 18)
		elif v > 0.2: (two.texture as AtlasTexture).region = Rect2i(20, 0, 18, 18)
		else: (two.texture as AtlasTexture).region = Rect2i(40, 0, 18, 18)
		if v > 0.1: (one.texture as AtlasTexture).region = Rect2i(0, 0, 18, 18)
		elif v > 0.0: (one.texture as AtlasTexture).region = Rect2i(20, 0, 18, 18)
		else: (one.texture as AtlasTexture).region = Rect2i(40, 0, 18, 18)
