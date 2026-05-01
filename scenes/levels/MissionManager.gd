extends Node2D

var enemies_alive: int = 0

func _ready() -> void:
	var return_button: Button = $CanvasLayer/PopupPanel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button
	return_button.pressed.connect(func(): return_to_menu())

func return_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu/Main Menu.tscn")

func register_enemy():
	enemies_alive += 1

func unregister_enemy():
	enemies_alive -= 1

	if enemies_alive <= 0:
		enemies_alive = 0
		$CanvasLayer/PopupPanel.popup_centered()
