class_name FrameOverlay
extends Control




var safe_rect: = Rect2()


func set_safe_rect(r: Rect2) -> void :
	safe_rect = r


func get_frame_rect() -> Rect2:
	if safe_rect.size.x < 1.0 or safe_rect.size.y < 1.0:
		return Rect2(Vector2.ZERO, size)
	return safe_rect
