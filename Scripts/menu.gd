extends Node2D


@onready var button_play: NinePatchRect = $ContainerButtons/ButtonPlay
@onready var button_config: NinePatchRect = $ContainerButtons/ButtonConfig
@onready var button_exit: NinePatchRect = $ContainerButtons/ButtonExit
@onready var back_ground_music: AudioStreamPlayer = $BackGroundMusic

func _ready() -> void:
	Global.load_settings()
	if back_ground_music:
		back_ground_music.bus = "Music"
		back_ground_music.play(Global.music_position)


func _on_button_play_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	var result = get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	if result == OK:
		print("Escena cambiada exitosamente")
	else:
		print("Error cambiando escena: ", result)
	# Opcional: mostrar mensaje de error al usuario


func _on_button_config_button_pressed() -> void:
	Global.music_position = back_ground_music.get_playback_position()
	await get_tree().create_timer(0.1).timeout
	var result = get_tree().change_scene_to_file("res://Scenes/config.tscn")
	if result == OK:
		print("Escena cambiada exitosamente")
	else:
		print("Error cambiando escena: ", result)
	# Opcional: mostrar mensaje de error al usuario


func _on_button_exit_button_pressed() -> void:
	Global.save()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
