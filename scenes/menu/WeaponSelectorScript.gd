extends Control

@export var weapon_scenes: Array[PackedScene]

var main_selections: Array[Button] = []

func _ready():
	Input.set_custom_mouse_cursor(null)

	var main_smg_button: Button = $MarginContainer2/VBoxContainer/HBoxContainer/MainSMG
	var main_ar_button: Button = $MarginContainer2/VBoxContainer/HBoxContainer/MainAR
	var main_rifle_button: Button = $MarginContainer2/VBoxContainer/HBoxContainer/MainRifle
	var confirm_button: Button = $MarginContainer2/VBoxContainer/HBoxContainer2/MenuButton
	
	confirm_button.pressed.connect(func(): _start_mission())
	
	main_selections.append(main_smg_button)
	main_selections.append(main_ar_button)
	main_selections.append(main_rifle_button)
	
	for i in range(main_selections.size()):
		main_selections[i].pressed.connect(func(): select_weapon(i))
	
	main_smg_button.button_pressed = true
	select_weapon(0)

func select_weapon(index):

	# Save to global
	GameState.selected_main_weapon = weapon_scenes[index]
	untoggle_other_button(main_selections, index)

	print("Selected:", index)

func untoggle_other_button(array: Array[Button], target: int):
	for i in range(array.size()):
		if i != target:
			array[i].button_pressed = false
	
func _start_mission():
	get_tree().change_scene_to_file("res://scenes/levels/Mission 1.tscn")
