extends Node2D

@onready var label: Label = $HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.GoldCoins:
		label.text = str(Global.GoldCoins)
