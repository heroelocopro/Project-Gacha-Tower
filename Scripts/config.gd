# Config.gd
extends Node2D

@onready var slider_sound: HSlider = $SliderSound
@onready var icon_sound: Sprite2D = $IconSound
@onready var slider_music: HSlider = $SliderMusic
@onready var icon_music: Sprite2D = $IconMusic
@onready var button_back: NinePatchRect = $ButtonBack
@onready var back_ground_music: AudioStreamPlayer = $BackGroundMusic

# Texturas para iconos según volumen
@export var sound_icons: Array[Texture2D] = [preload("uid://d38oinu2vnias"), preload("uid://covbv5gpxb1nm")]  # [mute, low, medium, high]
@export var music_icons: Array[Texture2D] = [preload("uid://05dyqbht0ahc"), preload("uid://dy0pond7mp4mj")]  # [mute, low, medium, high]



func _ready() -> void:
	setup_sliders()
	setup_icons()
	setup_button()
	
	# Configurar música de fondo
	if back_ground_music:
		back_ground_music.bus = "Music"
		back_ground_music.play(Global.music_position)

func setup_sliders():
	# Configurar sliders con valores actuales
	slider_sound.min_value = 0.0
	slider_sound.max_value = 1.0
	slider_sound.step = 0.01
	slider_sound.value = Global.get_sound_volume_linear()
	
	slider_music.min_value = 0.0
	slider_music.max_value = 1.0
	slider_music.step = 0.01
	slider_music.value = Global.get_music_volume_linear()
	
	## Conectar señales
	#slider_sound.connect("value_changed", Callable(self, "_on_slider_sound_value_changed"))
	#slider_music.connect("value_changed", Callable(self, "_on_slider_music_value_changed"))
	#
	## Para testear sonido al soltar
	#slider_sound.connect("drag_ended", Callable(self, "_on_sound_slider_released"))
	#slider_music.connect("drag_ended", Callable(self, "_on_music_slider_released"))

func setup_icons():
	update_sound_icon()
	update_music_icon()

func setup_button():
	if button_back.has_signal("button_pressed"):
		button_back.connect("button_pressed", Callable(self, "_on_button_back_button_pressed"))

func _on_slider_sound_value_changed(value: float) -> void:
	# Actualizar volumen global
	Global.set_sound_volume(value)
	
	# Actualizar icono
	update_sound_icon()

func _on_slider_music_value_changed(value: float) -> void:
	# Actualizar volumen global
	Global.set_music_volume(value)
	
	# Actualizar icono
	update_music_icon()

func update_sound_icon():
	if not icon_sound or sound_icons.is_empty():
		return
	
	var volume = slider_sound.value
	var icon_index = get_icon_index(volume)
	
	if icon_index < sound_icons.size():
		icon_sound.texture = sound_icons[icon_index]
	
	# Cambiar color según volumen
	update_icon_color(icon_sound, volume)

func update_music_icon():
	if not icon_music or music_icons.is_empty():
		return
	
	var volume = slider_music.value
	var icon_index = get_icon_index(volume)
	
	if icon_index < music_icons.size():
		icon_music.texture = music_icons[icon_index]
	
	# Cambiar color según volumen
	update_icon_color(icon_music, volume)

func get_icon_index(volume: float) -> int:
	if volume <= 0.01:
		return 0  # mute
	elif volume < 0.3:
		return 1  # low
	elif volume < 0.7:
		return 2  # medium
	else:
		return 3  # high

func update_icon_color(icon: Sprite2D, volume: float):
	if volume <= 0.01:
		icon.modulate = Color(0.6, 0.6, 0.6)  # Gris (mute)
	elif volume < 0.3:
		icon.modulate = Color(1.0, 0.5, 0.5)  # Rojo claro (bajo)
	elif volume < 0.7:
		icon.modulate = Color(1.0, 1.0, 0.5)  # Amarillo (medio)
	else:
		icon.modulate = Color(0.5, 1.0, 0.5)  # Verde claro (alto)


func _on_button_back_button_pressed() -> void:
	Global.music_position = back_ground_music.get_playback_position()
	# Guardar configuración
	Global.save()
	
	# Cambiar escena
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# Para manejar teclado (opcional)
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Tecla ESC
		_on_button_back_button_pressed()
