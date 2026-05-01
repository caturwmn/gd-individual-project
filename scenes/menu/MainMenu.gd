extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	var start_button: LinkButton = $CenterContainer/VBoxContainer2/HBoxContainer/VBoxContainer/LinkButton
	var exit_button: LinkButton = $CenterContainer/VBoxContainer2/HBoxContainer/VBoxContainer/LinkButton3
	start_button.pressed.connect(func(): _to_weapon_select())
	exit_button.pressed.connect(func(): _exit_game())
	
func _to_weapon_select() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/Weapon Select Screen.tscn")
	
func _exit_game() -> void:
	get_tree().quit()
