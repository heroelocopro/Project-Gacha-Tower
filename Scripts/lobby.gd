extends Node2D


const NPC_HADA = preload("uid://cnarn66jj5rx4")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	welcomePlayer()

func welcomePlayer():
	if Global.firstTime:
		var instancia = NPC_HADA.instantiate()
		instancia.dialogos = [
			"Bienvenido a GACHA TOWER tu objetivo es escalar la torre con ayuda de tus heroes",
			"Suerte"
			]
		instancia.position = Vector2(184, 1688)
		self.add_child(instancia)
		Global.firstTime = false
		Global.save_data()
	else:
		print("No es primera vez")

func _on_button_back_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	var result = get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	if result != OK:
		print("Error al cambiar escena lobby script #12")
