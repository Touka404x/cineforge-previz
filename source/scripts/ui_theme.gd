class_name UITheme
extends RefCounted




const TEXT: = Color("1f2937")
const TEXT_DIM: = Color("6b7280")
const CARD: = Color("ffffff")
const BORDER: = Color("e5e7eb")
const FIELD: = Color("f9fafb")
const HOVER: = Color("f3f4f6")
const PRESSED: = Color("e5e7eb")
const ACCENT: = Color("111827")
const ACCENT_HOVER: = Color("374151")
const SEG_BG: = Color("eceef1")
const SELECT_BG: = Color("eef2ff")
const SELECT_BORDER: = Color("818cf8")
const KEY_CAM: = Color("f59e0b")
const KEY_OBJ: = Color("0ea5e9")
const PLAYHEAD: = Color("ef4444")


static func _flat(bg: Color, radius: = 8, border: = Color(0, 0, 0, 0), 
		border_w: = 0, margin: = 8) -> StyleBoxFlat:
	var sb: = StyleBoxFlat.new()
	sb.bg_color = bg
	sb.set_corner_radius_all(radius)
	if border_w > 0:
		sb.border_color = border
		sb.set_border_width_all(border_w)
	sb.set_content_margin_all(margin)
	return sb



static func _close_x_icon(col: Color) -> ImageTexture:
	var s: = 16
	var img: = Image.create(s, s, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	for i in range(4, s - 4):
		for off in [0, 1]:
			var y_down: int = i + off
			var y_up: int = s - 1 - i + off
			if y_down < s:
				img.set_pixel(i, y_down, col)
			if y_up >= 0 and y_up < s:
				img.set_pixel(i, y_up, col)
	return ImageTexture.create_from_image(img)





static func style_dialog(dlg: Window) -> void :

	dlg.transparent_bg = true

	var wb: = _flat(CARD, 14, BORDER, 1, 0)
	wb.expand_margin_top = 36.0
	wb.shadow_size = 24
	wb.shadow_color = Color(0.1, 0.12, 0.18, 0.18)
	wb.shadow_offset = Vector2(0, 6)
	dlg.add_theme_stylebox_override("embedded_border", wb)
	dlg.add_theme_stylebox_override("embedded_unfocused_border", wb)
	var dlg_panel: = StyleBoxEmpty.new()
	dlg_panel.set_content_margin_all(16)
	dlg.add_theme_stylebox_override("panel", dlg_panel)
	dlg.add_theme_color_override("title_color", TEXT)
	dlg.add_theme_font_size_override("title_font_size", 15)
	if ResourceLoader.exists("res://fonts/MiSans-Demibold.ttf"):

		dlg.add_theme_font_override("title_font", load("res://fonts/MiSans-Demibold.ttf"))
	dlg.add_theme_icon_override("close", _close_x_icon(TEXT_DIM))
	dlg.add_theme_icon_override("close_pressed", _close_x_icon(TEXT))


static func build() -> Theme:
	var t: = Theme.new()
	var sys_fallback: = SystemFont.new()
	sys_fallback.font_names = PackedStringArray(
		["Microsoft YaHei UI", "Microsoft YaHei", "SimHei"])
	var font: Font = sys_fallback
	var title_font: Font = sys_fallback
	if ResourceLoader.exists("res://fonts/MiSans-Regular.ttf"):
		var mis: = load("res://fonts/MiSans-Regular.ttf") as FontFile
		if mis:
			mis.fallbacks = [sys_fallback]
			font = mis
	if ResourceLoader.exists("res://fonts/MiSans-Demibold.ttf"):
		var misd: = load("res://fonts/MiSans-Demibold.ttf") as FontFile
		if misd:
			misd.fallbacks = [sys_fallback]
			title_font = misd
	t.default_font = font
	t.default_font_size = 14
	t.set_font("font", "TitleLabel", title_font)
	t.set_font("font", "PrimaryButton", title_font)
	t.set_font("font", "ModeCard", title_font)


	var card: = _flat(CARD, 16, Color("eceef2"), 1, 16)
	card.shadow_size = 14
	card.shadow_color = Color(0.1, 0.12, 0.18, 0.06)
	card.shadow_offset = Vector2(0, 5)
	t.set_stylebox("panel", "PanelContainer", card)


	t.set_type_variation("TopBar", "PanelContainer")
	var top: = _flat(CARD, 0, BORDER, 0, 8)
	top.border_width_bottom = 1
	top.border_color = BORDER
	t.set_stylebox("panel", "TopBar", top)


	t.set_type_variation("SegGroup", "PanelContainer")
	t.set_stylebox("panel", "SegGroup", _flat(SEG_BG, 10, Color(0, 0, 0, 0), 0, 4))


	t.set_type_variation("Chip", "PanelContainer")
	var chip: = _flat(CARD, 999, BORDER, 1, 10)
	chip.shadow_size = 8
	chip.shadow_color = Color(0.1, 0.12, 0.18, 0.08)
	t.set_stylebox("panel", "Chip", chip)


	for c in [["font_color", TEXT], ["font_hover_color", TEXT], 
			["font_pressed_color", TEXT], ["font_focus_color", TEXT], 
			["font_hover_pressed_color", TEXT], 
			["font_disabled_color", Color("c3c8d0")]]:
		t.set_color(c[0], "Button", c[1])
	t.set_stylebox("normal", "Button", _flat(FIELD, 8, BORDER, 1))
	t.set_stylebox("hover", "Button", _flat(HOVER, 8, BORDER, 1))
	t.set_stylebox("pressed", "Button", _flat(PRESSED, 8, BORDER, 1))
	t.set_stylebox("hover_pressed", "Button", _flat(PRESSED, 8, BORDER, 1))
	t.set_stylebox("disabled", "Button", _flat(Color("fbfcfd"), 8, Color("f0f1f3"), 1))
	t.set_stylebox("focus", "Button", StyleBoxEmpty.new())


	t.set_type_variation("PrimaryButton", "Button")
	t.set_stylebox("normal", "PrimaryButton", _flat(ACCENT, 10, Color(0, 0, 0, 0), 0, 10))
	t.set_stylebox("hover", "PrimaryButton", _flat(ACCENT_HOVER, 10, Color(0, 0, 0, 0), 0, 10))
	t.set_stylebox("pressed", "PrimaryButton", _flat(ACCENT, 10, Color(0, 0, 0, 0), 0, 10))
	for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		t.set_color(c, "PrimaryButton", Color.WHITE)


	t.set_type_variation("DangerChip", "Button")
	t.set_stylebox("normal", "DangerChip", _flat(Color("fff5f5"), 8, Color("e5484d"), 1))
	t.set_stylebox("hover", "DangerChip", _flat(Color("e5484d"), 8, Color("e5484d"), 1))
	t.set_stylebox("pressed", "DangerChip", _flat(Color("c62a2f"), 8, Color("c62a2f"), 1))
	t.set_stylebox("hover_pressed", "DangerChip", _flat(Color("c62a2f"), 8, Color("c62a2f"), 1))
	t.set_color("font_color", "DangerChip", Color("e5484d"))
	t.set_color("font_hover_color", "DangerChip", Color.WHITE)
	t.set_color("font_pressed_color", "DangerChip", Color.WHITE)


	t.set_type_variation("GhostButton", "Button")
	t.set_stylebox("normal", "GhostButton", _flat(Color(1, 1, 1, 0), 8))
	t.set_stylebox("hover", "GhostButton", _flat(HOVER, 8))
	t.set_stylebox("pressed", "GhostButton", _flat(PRESSED, 8))
	t.set_stylebox("hover_pressed", "GhostButton", _flat(PRESSED, 8))


	t.set_type_variation("ToggleChip", "Button")
	t.set_stylebox("normal", "ToggleChip", _flat(FIELD, 8, BORDER, 1))
	t.set_stylebox("hover", "ToggleChip", _flat(HOVER, 8, BORDER, 1))
	t.set_stylebox("pressed", "ToggleChip", _flat(SELECT_BG, 8, SELECT_BORDER, 1))
	t.set_stylebox("hover_pressed", "ToggleChip", _flat(SELECT_BG, 8, SELECT_BORDER, 1))
	t.set_color("font_pressed_color", "ToggleChip", Color("4f46e5"))
	t.set_color("font_hover_pressed_color", "ToggleChip", Color("4f46e5"))


	t.set_type_variation("SegButton", "Button")
	t.set_stylebox("normal", "SegButton", _flat(Color(1, 1, 1, 0), 8))
	t.set_stylebox("hover", "SegButton", _flat(Color(1, 1, 1, 0.5), 8))
	var seg_on: = _flat(CARD, 8, BORDER, 1)
	seg_on.shadow_size = 4
	seg_on.shadow_color = Color(0.1, 0.12, 0.18, 0.08)
	t.set_stylebox("pressed", "SegButton", seg_on)
	t.set_stylebox("hover_pressed", "SegButton", seg_on)
	t.set_color("font_color", "SegButton", TEXT_DIM)
	t.set_color("font_pressed_color", "SegButton", TEXT)
	t.set_color("font_hover_pressed_color", "SegButton", TEXT)


	t.set_type_variation("ModeCard", "Button")
	t.set_stylebox("normal", "ModeCard", _flat(FIELD, 12, BORDER, 1, 12))
	t.set_stylebox("hover", "ModeCard", _flat(HOVER, 12, BORDER, 1, 12))
	var mode_on: = _flat(CARD, 12, ACCENT, 2, 12)
	mode_on.shadow_size = 6
	mode_on.shadow_color = Color(0.1, 0.12, 0.18, 0.1)
	t.set_stylebox("pressed", "ModeCard", mode_on)
	t.set_stylebox("hover_pressed", "ModeCard", mode_on)
	t.set_color("font_color", "ModeCard", TEXT_DIM)
	t.set_color("font_pressed_color", "ModeCard", TEXT)
	t.set_color("font_hover_pressed_color", "ModeCard", TEXT)


	t.set_type_variation("SegDark", "Button")
	t.set_stylebox("normal", "SegDark", _flat(Color(1, 1, 1, 0), 999))
	t.set_stylebox("hover", "SegDark", _flat(HOVER, 999))
	var seg_dark: = _flat(ACCENT, 999)
	t.set_stylebox("pressed", "SegDark", seg_dark)
	t.set_stylebox("hover_pressed", "SegDark", seg_dark)
	t.set_color("font_color", "SegDark", TEXT_DIM)
	t.set_color("font_pressed_color", "SegDark", Color.WHITE)
	t.set_color("font_hover_pressed_color", "SegDark", Color.WHITE)


	t.set_type_variation("AssetCard", "Button")
	t.set_stylebox("normal", "AssetCard", _flat(Color("f1f3f6"), 12, Color(0, 0, 0, 0), 0, 8))
	t.set_stylebox("hover", "AssetCard", _flat(Color("eceef4"), 12, SELECT_BORDER, 1, 8))
	t.set_stylebox("pressed", "AssetCard", _flat(SELECT_BG, 12, SELECT_BORDER, 1, 8))
	t.set_font_size("font_size", "AssetCard", 12)
	t.set_color("font_color", "AssetCard", TEXT)


	t.set_type_variation("PlayBig", "Button")
	t.set_stylebox("normal", "PlayBig", _flat(ACCENT, 999, Color(0, 0, 0, 0), 0, 0))
	t.set_stylebox("hover", "PlayBig", _flat(ACCENT_HOVER, 999, Color(0, 0, 0, 0), 0, 0))
	t.set_stylebox("pressed", "PlayBig", _flat(ACCENT, 999, Color(0, 0, 0, 0), 0, 0))
	for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		t.set_color(c, "PlayBig", Color.WHITE)
	t.set_font_size("font_size", "PlayBig", 20)


	t.set_type_variation("RowSelected", "Button")
	t.set_stylebox("normal", "RowSelected", _flat(SELECT_BG, 8, SELECT_BORDER, 1))
	t.set_stylebox("hover", "RowSelected", _flat(SELECT_BG, 8, SELECT_BORDER, 1))
	t.set_stylebox("pressed", "RowSelected", _flat(SELECT_BG, 8, SELECT_BORDER, 1))


	t.set_stylebox("normal", "MenuButton", _flat(Color(1, 1, 1, 0), 8))
	t.set_stylebox("hover", "MenuButton", _flat(HOVER, 8))
	t.set_stylebox("pressed", "MenuButton", _flat(PRESSED, 8))
	t.set_stylebox("focus", "MenuButton", StyleBoxEmpty.new())
	t.set_color("font_color", "MenuButton", TEXT)
	t.set_color("font_hover_color", "MenuButton", TEXT)
	t.set_color("font_pressed_color", "MenuButton", TEXT)
	t.set_color("font_focus_color", "MenuButton", TEXT)


	var pop: = _flat(CARD, 10, BORDER, 1, 6)
	pop.shadow_size = 14
	pop.shadow_color = Color(0.1, 0.12, 0.18, 0.12)
	t.set_stylebox("panel", "PopupMenu", pop)
	t.set_stylebox("hover", "PopupMenu", _flat(HOVER, 6))
	t.set_color("font_color", "PopupMenu", TEXT)
	t.set_color("font_hover_color", "PopupMenu", TEXT)
	t.set_color("font_accelerator_color", "PopupMenu", TEXT_DIM)
	t.set_color("font_disabled_color", "PopupMenu", Color("c3c8d0"))
	t.set_color("font_separator_color", "PopupMenu", TEXT_DIM)


	t.set_color("font_color", "Label", TEXT)
	t.set_type_variation("DimLabel", "Label")
	t.set_color("font_color", "DimLabel", TEXT_DIM)
	t.set_font_size("font_size", "DimLabel", 12)
	t.set_type_variation("TitleLabel", "Label")
	t.set_font_size("font_size", "TitleLabel", 15)


	t.set_stylebox("normal", "LineEdit", _flat(FIELD, 8, BORDER, 1))
	t.set_stylebox("focus", "LineEdit", _flat(CARD, 8, SELECT_BORDER, 1))
	t.set_stylebox("read_only", "LineEdit", _flat(FIELD, 8, BORDER, 1))
	t.set_color("font_color", "LineEdit", TEXT)
	t.set_color("font_placeholder_color", "LineEdit", TEXT_DIM)
	t.set_color("caret_color", "LineEdit", TEXT)
	t.set_color("selection_color", "LineEdit", Color("c7d2fe"))


	var track: = _flat(Color("e5e7eb"), 3, Color(0, 0, 0, 0), 0, 0)
	track.content_margin_top = 2
	track.content_margin_bottom = 2
	t.set_stylebox("slider", "HSlider", track)
	var filled: = _flat(ACCENT, 3, Color(0, 0, 0, 0), 0, 0)
	t.set_stylebox("grabber_area", "HSlider", filled)
	t.set_stylebox("grabber_area_highlight", "HSlider", filled)


	var sep_line: = StyleBoxLine.new()
	sep_line.color = BORDER
	t.set_stylebox("separator", "HSeparator", sep_line)
	var vsep_line: = StyleBoxLine.new()
	vsep_line.color = BORDER
	vsep_line.vertical = true
	t.set_stylebox("separator", "VSeparator", vsep_line)


	t.set_stylebox("panel", "ScrollContainer", StyleBoxEmpty.new())





	t.set_color("font_color", "CheckBox", TEXT)
	return t
