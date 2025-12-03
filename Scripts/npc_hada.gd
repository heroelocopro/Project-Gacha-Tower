extends Node2D

@onready var label: Label = $ContainerText/Label
@export  var dialogos : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npcTalk()
func npcTalk():
	if label:
		for dialogo in dialogos:
			if is_inside_tree():
				await get_tree().create_timer(1).timeout
				label.text = "" 
			for palabra in dialogo:
				if is_inside_tree():
					await get_tree().create_timer(0.07).timeout
					label.text += palabra
		if is_inside_tree():
			await get_tree().create_timer(1).timeout
			self.free()
