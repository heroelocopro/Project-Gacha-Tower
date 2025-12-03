extends NinePatchRect

signal buttonPressed

@export var fontSize : int
@export var buttonIcon : CompressedTexture2D
@export var buttonSoundClic : AudioStream
@export var buttonText : String
@onready var button: Button = $Button
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $Button/AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if buttonIcon != null:
		button.icon = buttonIcon
	if buttonText != null:
		button.text = buttonText
	else:
		button.text = ""
	if fontSize != null:
		button.add_theme_font_size_override("font_size", fontSize)
	if buttonSoundClic != null:
		audio_stream_player_2d.stream = buttonSoundClic
	if button != null:
		button.connect("pressed",_on_pressed_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_pressed_button():
	if buttonSoundClic != null:
		audio_stream_player_2d.play()
	buttonPressed.emit()
