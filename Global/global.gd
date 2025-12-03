extends Node

# Configuración del juego
var GAME_TITLE = "GACHA TOWER"
var timeSongMenu = 0
var GoldCoins = 0.0
var firstTime = true

# Configuración de audio - VALORES EN DECIBELES
var sound_volume_db: float = 0.0      # 0 dB = volumen normal
var music_volume_db: float = 0.0
# Música
var music_position: float = 0.0

# Configuración de persistencia
const DATA_PATH = "user://data.cfg"
const SETTINGS_PATH = "user://settings.cfg"

func save_data():
	var data = ConfigFile.new()
	
	# Guardar Datos
	data.set_value("data", "coins", GoldCoins)
	data.set_value("data","firstTime",firstTime)
	
	# Guardar archivo
	var error = data.save(DATA_PATH)
	if error != OK:
		push_error("Error guardando configuración: " + str(error))

func load_data():
	var data = ConfigFile.new()
	
	if data.load(DATA_PATH) == OK:
		#obtenemos los datos
		GoldCoins = data.get_value("data","coins",0.0)
		firstTime = data.get_value("data","firstTime",true)
	else:
		GoldCoins = 100.00
		firstTime = true
		save_data()

func _ready() -> void:
	# Cargar configuración guardada
	load_data()
	load_settings()
	
# Métodos para audio
func set_sound_volume(linear_value: float) -> void:
	sound_volume_db = linear_to_db(linear_value)
	apply_audio_settings()

func set_music_volume(linear_value: float) -> void:
	music_volume_db = linear_to_db(linear_value)
	apply_audio_settings()

func get_sound_volume_linear() -> float:
	return db_to_linear(sound_volume_db)

func get_music_volume_linear() -> float:
	return db_to_linear(music_volume_db)

func apply_audio_settings() -> void:
	# Verificar que los buses existan
	var sound_bus_idx = AudioServer.get_bus_index("SFX")
	var music_bus_idx = AudioServer.get_bus_index("Music")
	
	if sound_bus_idx != -1:
		AudioServer.set_bus_volume_db(sound_bus_idx, sound_volume_db)
	
	if music_bus_idx != -1:
		AudioServer.set_bus_volume_db(music_bus_idx, music_volume_db)
	
	# Guardar automáticamente cuando cambian
	save()

# Persistencia
func save() -> void:
	var config = ConfigFile.new()
	
	# Guardar configuraciones de audio
	config.set_value("audio", "sound_volume_db", sound_volume_db)
	config.set_value("audio", "music_volume_db", music_volume_db)
	config.set_value("game", "time_song_menu", timeSongMenu)
	config.set_value("audio",'music_position',music_position)
	
	# Guardar archivo
	var error = config.save(SETTINGS_PATH)
	if error != OK:
		push_error("Error guardando configuración: " + str(error))

func load_settings() -> void:
	var config = ConfigFile.new()
	
	if config.load(SETTINGS_PATH) == OK:
		# Cargar audio
		sound_volume_db = config.get_value("audio", "sound_volume_db", 0.0)
		music_volume_db = config.get_value("audio", "music_volume_db", 0.0)
		timeSongMenu = config.get_value("game", "time_song_menu", 0.0)
		music_position = config.get_value("audio","music_position",0.0)
		
		# Aplicar configuraciones cargadas
		apply_audio_settings()
	else:
		# Valores por defecto
		sound_volume_db = 0.0
		music_volume_db = 0.0
		apply_audio_settings()
		save()  # Crear archivo con valores por defecto

# Métodos de utilidad
func play_sound(sound_stream: AudioStream, bus_name: String = "SFX") -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.stream = sound_stream
	player.bus = bus_name
	player.finished.connect(player.queue_free)
	
	# Añadir a la escena actual
	var scene_root = get_tree().current_scene
	if scene_root:
		scene_root.add_child(player)
	
	player.play()
	return player

func play_music(music_stream: AudioStream, loop: bool = true) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.stream = music_stream
	player.bus = "Music"
	
	if loop:
		player.finished.connect(player.play)
	
	# Añadir a la escena actual
	var scene_root = get_tree().current_scene
	if scene_root:
		scene_root.add_child(player)
	
	player.play()
	return player
