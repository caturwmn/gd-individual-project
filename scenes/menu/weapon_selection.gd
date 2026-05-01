@tool
extends Button

@onready var texture_rectangle: TextureRect = $VBoxContainer/TextureRect
@onready var weapon_label: Label = $VBoxContainer/HBoxContainer/Label

@export var weapon_sprite: Texture2D:
	set(value):
		weapon_sprite = value
		# Update texture immediately when changed in inspector
		if is_inside_tree():
			texture_rectangle.texture = weapon_sprite

@export var weapon_name: String = "SMG":
	set(value):
		weapon_name = value
		# Update label immediately when changed in inspector
		if is_inside_tree():
			weapon_label.text = weapon_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if weapon_sprite:
		texture_rectangle.texture = weapon_sprite
		
	if weapon_name:
		weapon_label.text = weapon_name
