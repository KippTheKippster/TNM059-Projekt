extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.color = Color.TRANSPARENT

func start(time: float) -> void:
	var tween := create_tween()
	tween.tween_property(color_rect, "color", Color.WHITE, time)
	tween.finished.connect(stop)

func stop() -> void:
	await get_tree().create_timer(2).timeout
	var tween := create_tween()
	tween.tween_property(color_rect, "color", Color.TRANSPARENT, 3.0)
