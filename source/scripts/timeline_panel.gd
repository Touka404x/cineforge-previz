class_name TimelinePanel
extends Control




signal scrubbed(t: float)

const GUTTER: = 104.0
const MARGIN_R: = 14.0
const HEADER_H: = 20.0
const ROW_H: = 24.0

var duration: = 8.0:
	set(v):
		duration = maxf(v, 0.1)
		queue_redraw()

var playhead: = 0.0:
	set(v):
		playhead = clampf(v, 0.0, duration)
		queue_redraw()

var tracks: Array = []


func _ready() -> void :
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_tracks([])


func set_tracks(t: Array) -> void :
	tracks = t
	custom_minimum_size = Vector2(200, HEADER_H + maxf(tracks.size(), 1.0) * ROW_H + 8)
	queue_redraw()


func _x_of(t: float) -> float:
	return GUTTER + (t / duration) * (size.x - GUTTER - MARGIN_R)


func _t_of(x: float) -> float:
	return clampf((x - GUTTER) / maxf(size.x - GUTTER - MARGIN_R, 1.0) * duration, 
		0.0, duration)


func _draw() -> void :
	var bg: = StyleBoxFlat.new()
	bg.bg_color = Color("f6f7f9")
	bg.set_corner_radius_all(10)
	draw_style_box(bg, Rect2(Vector2.ZERO, size))
	var font: = get_theme_default_font()

	var step: = 1.0
	if duration > 30.0:
		step = 5.0
	elif duration > 15.0:
		step = 2.0
	var t: = 0.0
	while t <= duration + 0.001:
		var x: = _x_of(t)
		draw_line(Vector2(x, HEADER_H), Vector2(x, size.y - 6), Color(0, 0, 0, 0.07))
		draw_string(font, Vector2(x + 4, 15), "%ds" % int(round(t)), 
			HORIZONTAL_ALIGNMENT_LEFT, -1, 11, UITheme.TEXT_DIM)
		t += step

	for i in range(tracks.size()):
		var row: Dictionary = tracks[i]
		var cy: = HEADER_H + i * ROW_H + ROW_H * 0.5
		if i > 0:
			draw_line(Vector2(6, HEADER_H + i * ROW_H), Vector2(size.x - 6, HEADER_H + i * ROW_H), 
				Color(0, 0, 0, 0.05))
		var row_name: = String(row.name)
		if row_name.length() > 7:
			row_name = row_name.substr(0, 6) + "…"
		draw_string(font, Vector2(10, cy + 5), row_name, 
			HORIZONTAL_ALIGNMENT_LEFT, GUTTER - 16, 12, row.color)
		for k in row.keys:
			var x: = _x_of(float(k.t))
			var pts: = PackedVector2Array([
				Vector2(x, cy - 6), Vector2(x + 6, cy), Vector2(x, cy + 6), Vector2(x - 6, cy), 
			])
			draw_colored_polygon(pts, row.color)
	if tracks.is_empty():
		draw_string(font, Vector2(GUTTER + 12, HEADER_H + 18), "按 K 打相机关键帧开始", 
			HORIZONTAL_ALIGNMENT_LEFT, -1, 12, UITheme.TEXT_DIM)

	var px: = _x_of(playhead)
	draw_line(Vector2(px, 4), Vector2(px, size.y - 4), UITheme.PLAYHEAD, 2.0)
	draw_string(font, Vector2(px + 5, size.y - 6), "%.2fs" % playhead, 
		HORIZONTAL_ALIGNMENT_LEFT, -1, 11, UITheme.PLAYHEAD)


func _gui_input(event: InputEvent) -> void :
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		playhead = _t_of(event.position.x)
		scrubbed.emit(playhead)
	elif event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		playhead = _t_of(event.position.x)
		scrubbed.emit(playhead)
