extends Node3D








const APP_VERSION: = "0.9.3"

const CINEFORGE_BASE: = ""

const UPDATE_MANIFEST_URL: = ""

const JOB_PATH: = "user://render_job.json"
const SETTINGS_PATH: = "user://settings.json"

const SCALE_ITEMS: = [
	["自动", 0.0, 100], ["100%", 1.0, 101], ["125%", 1.25, 102], 
	["150%", 1.5, 103], ["175%", 1.75, 104], ["200%", 2.0, 105], 
]

const KIND_ICONS: = {
	"box": "▢", "sphere": "○", "cylinder": "▯", "panel": "▭", "ramp": "◺", 
	"figure": "人", "model": "◈", "group": "▣", 
}

const ENV_PRESETS: = {
	"day": {"cn": "白天", "elev": -52.0, "energy": 0.9, 
		"sun": Color(1.0, 0.98, 0.94), "sky": Color("dfe6ee"), 
		"amb": Color(0.86, 0.87, 0.89), "amb_e": 0.55}, 
	"dusk": {"cn": "黄昏", "elev": -13.0, "energy": 0.85, 
		"sun": Color(1.0, 0.6, 0.36), "sky": Color("e2a273"), 
		"amb": Color(0.82, 0.62, 0.52), "amb_e": 0.42}, 
	"night": {"cn": "夜晚", "elev": -38.0, "energy": 0.22, 
		"sun": Color(0.62, 0.72, 1.0), "sky": Color("222b3e"), 
		"amb": Color(0.42, 0.52, 0.82), "amb_e": 0.32}, 
	"overcast": {"cn": "阴天", "elev": -62.0, "energy": 0.38, 
		"sun": Color(0.9, 0.92, 0.95), "sky": Color("c7ccd3"), 
		"amb": Color(0.8, 0.82, 0.85), "amb_e": 0.75}, 
}
const ENV_ORDER: = ["day", "dusk", "night", "overcast"]


const CAM_PRESETS: = [
	{"key": "static_shot", "cn": "固定机位", "cat": "基础运镜"}, 
	{"key": "push", "cn": "镜头推进", "cat": "基础运镜"}, 
	{"key": "pull", "cn": "镜头后撤", "cat": "基础运镜"}, 
	{"key": "rise", "cn": "镜头升高", "cat": "基础运镜"}, 
	{"key": "lower", "cn": "镜头降低", "cat": "基础运镜"}, 
	{"key": "truck_left", "cn": "镜头左移", "cat": "基础运镜"}, 
	{"key": "truck_right", "cn": "镜头右移", "cat": "基础运镜"}, 
	{"key": "push_rise", "cn": "推进升高", "cat": "基础运镜"}, 
	{"key": "pull_rise", "cn": "后撤升高", "cat": "基础运镜"}, 
	{"key": "pan_up", "cn": "向上摇镜", "cat": "摇镜·变焦"}, 
	{"key": "pan_down", "cn": "向下摇镜", "cat": "摇镜·变焦"}, 
	{"key": "pan_left", "cn": "向左摇镜", "cat": "摇镜·变焦"}, 
	{"key": "pan_right", "cn": "向右摇镜", "cat": "摇镜·变焦"}, 
	{"key": "zoom_in", "cn": "变焦推进", "cat": "摇镜·变焦"}, 
	{"key": "zoom_out", "cn": "变焦拉远", "cat": "摇镜·变焦"}, 
	{"key": "dolly_zoom", "cn": "希区柯克变焦", "cat": "摇镜·变焦"}, 
	{"key": "orbit90", "cn": "环绕镜头", "cat": "环绕"}, 
	{"key": "orbit180", "cn": "环绕 180°", "cat": "环绕"}, 
	{"key": "orbit_rise", "cn": "环绕上升", "cat": "环绕"}, 
	{"key": "orbit_fall", "cn": "环绕下降", "cat": "环绕"}, 
	{"key": "orbit_push", "cn": "环绕推进", "cat": "环绕"}, 
	{"key": "spiral", "cn": "螺旋环绕上升", "cat": "环绕"}, 
	{"key": "dream_orbit", "cn": "梦幻环绕", "cat": "环绕"}, 
	{"key": "bullet_time", "cn": "子弹时间", "cat": "环绕"}, 
	{"key": "follow_left", "cn": "左侧跟随", "cat": "跟随·视角"}, 
	{"key": "follow_right", "cn": "右侧跟随", "cat": "跟随·视角"}, 
	{"key": "follow_push", "cn": "跟随推进", "cat": "跟随·视角"}, 
	{"key": "low_push", "cn": "低角度推进", "cat": "跟随·视角"}, 
	{"key": "shoulder_push", "cn": "过肩推进", "cat": "跟随·视角"}, 
	{"key": "pov", "cn": "第一视角", "cat": "跟随·视角"}, 
	{"key": "handheld", "cn": "手持逼近", "cat": "跟随·视角"}, 
	{"key": "rise_top", "cn": "拉升俯瞰", "cat": "高空"}, 
	{"key": "top_fall", "cn": "顶拍下降", "cat": "高空"}, 
	{"key": "god_view", "cn": "上帝俯瞰", "cat": "高空"}, 
	{"key": "flyover", "cn": "高空掠过", "cat": "高空"}, 
	{"key": "low_pass", "cn": "贴地飞掠", "cat": "高空"}, 
	{"key": "dive", "cn": "俯冲下压", "cat": "高空"}, 
	{"key": "hero_intro", "cn": "英雄登场", "cat": "叙事·氛围"}, 
	{"key": "menace", "cn": "危机逼近", "cat": "叙事·氛围"}, 
	{"key": "epic_open", "cn": "大场面开场", "cat": "叙事·氛围"}, 
	{"key": "intimate", "cn": "亲密对话", "cat": "叙事·氛围"}, 
	{"key": "standoff", "cn": "对峙时刻", "cat": "叙事·氛围"}, 
	{"key": "reveal", "cn": "关键揭示", "cat": "叙事·氛围"}, 
	{"key": "peek", "cn": "秘密窥视", "cat": "叙事·氛围"}, 
	{"key": "dutch", "cn": "悬疑失衡", "cat": "叙事·氛围"}, 
	{"key": "barrel_roll", "cn": "画面翻滚", "cat": "叙事·氛围"}, 
	{"key": "chase", "cn": "动作追逐", "cat": "叙事·氛围"}, 
	{"key": "fg_sweep", "cn": "前景掠过", "cat": "叙事·氛围"}, 
]

var fly_cam: FlyCamera
var scene_manager: SceneManager
var timeline: TimelinePanel
var export_manager: ExportManager


var shots: Array[Dictionary] = []
var cur_shot: = 0
var shot_fps: = 60
var playhead: = 0.0
var playing: = false
var playing_all: = false


var auto_mode: = true
var auto_row: HBoxContainer
var manual_row: HBoxContainer
var track_mode_auto_btn: Button
var track_mode_manual_btn: Button
var auto_count_label: Label
var wp_scroll: ScrollContainer
var wp_strip: HBoxContainer

var render_mode: = false
var shoot_mode: = false
var grid: MeshInstance3D
var ground: MeshInstance3D
var sun: DirectionalLight3D
var env_res: Environment
var env_preset: = "day"
var sun_azimuth: = 32.0
var labels_burn: = false


var ui_layer: CanvasLayer
var ui_theme: Theme

var blur_layer: CanvasLayer
var blur_mat: ShaderMaterial
var _cam_prev_pos: = Vector3.ZERO
var _cam_prev_euler: = Vector3.ZERO
var _blur_test: = false
var motion_blur_on: = true
var blur_check: Button
const MOTION_BLUR_SHADER: = "shader_type canvas_item;\nuniform float blur_amt = 0.0;\nuniform sampler2D screen_tex : hint_screen_texture, filter_linear;\nvoid fragment() {\n\tvec2 dir = (SCREEN_UV - vec2(0.5)) * blur_amt;\n\tvec3 c = vec3(0.0);\n\tfor (int i = 0; i < 6; i++) {\n\t\tc += texture(screen_tex, SCREEN_UV - dir * (float(i) / 5.0 - 0.5)).rgb;\n\t}\n\tCOLOR = vec4(c / 6.0, 1.0);\n}"










var frame_overlay: FrameOverlay
var fps_opt: OptionButton
const FPS_OPTIONS: = [24, 25, 30, 60]
var status_chip: PanelContainer
var status_label: Label
var mode_card_layout: Button
var mode_card_shoot: Button
var layout_left_panel: PanelContainer
var shoot_left_panel: PanelContainer
var right_panel: PanelContainer
var right_tab_tools: VBoxContainer
var right_tab_assets: VBoxContainer
var obj_list_box: VBoxContainer
var props_box: VBoxContainer
var tab_transform_box: VBoxContainer
var tab_material_box: VBoxContainer
var tab_light_box: VBoxContainer
var pose_box: VBoxContainer
var crowd_dialog: ConfirmationDialog
var new_dialog: ConfirmationDialog
var _crowd_rows: SpinBox
var _crowd_cols: SpinBox
var _crowd_gap: SpinBox
var _crowd_count_label: Label
var _crowd_counter: = 0
var bottom_card: PanelContainer
var clip_strip: HBoxContainer
var view_card: PanelContainer
var name_edit: LineEdit
var color_btn: ColorPickerButton
var fov_slider: HSlider
var fov_value_label: Label
var snap_check: Button
var loop_check: Button
var pause_key_check: Button
var label_check: Button
var burn_check: Button
var duration_spin: SpinBox
var auto_dur_spin: SpinBox
var handheld_check: Button
var handheld_slider: HSlider
var _handheld_amp: = 0.5
var play_btn: Button
var time_label: Label
var export_btn: Button
var project_label: Label
var view_menu: PopupMenu
var view_persp_btn: Button
var view_two_btn: Button
var help_dialog: AcceptDialog
var lib_cat_opt: OptionButton
var lib_search: LineEdit
var lib_grid: GridContainer
var fps_label: Label
var _env_chips: Dictionary = {}
var _azimuth_slider: HSlider
var _spin: Dictionary = {}
var _insp_updating: = false
var _fps_timer: = 0.0

var ui_scale_setting: = 0.0
var project_path: = ""
var scale_lock: = true


var model_index: Dictionary = {}
var model_lookup: Dictionary = {}


var _dragging: = false
var _drag_plane_y: = 0.0
var _drag_pos: = Vector3.ZERO
var drag_sensitivity: = 0.7
var gizmo: TranslateGizmo
var _axis_drag: = ""
var _axis_dir: = Vector3.ZERO
var _axis_anchor: = Vector3.ZERO
var _axis_t0: = 0.0
var _obj_start_pos: = Vector3.ZERO
var _drag_starts: Dictionary = {}


var _undo_stack: Array = []
var _undo_pushed_this_drag: = false
const UNDO_MAX: = 40


var _rot_drag: = ""
var _rot_axis: = Vector3.ZERO
var _rot_u: = Vector3.ZERO
var _rot_v: = Vector3.ZERO
var _rot_origin: = Vector3.ZERO
var _rot_start_angle: = 0.0
var _rot_start_basis: = Basis.IDENTITY


var scale_handle: MeshInstance3D
var _scaling: = false
var _scale_start: = Vector3.ONE
var _scale_pivot_scr: = Vector2.ZERO
var _scale_d0: = 1.0
var _scale_bottom: = 0.0
var _scale_aabb_miny: = 0.0


var thumb_vp: SubViewport
var thumb_cam: Camera3D
var _thumb_busy: = false

var _save_dialog: FileDialog
var _open_dialog: FileDialog
var _export_dialog: FileDialog
var _still_dialog: FileDialog
var _file_menu_pop: PopupMenu
var recent_files: Array = []


var updater: Updater
var update_dialog: ConfirmationDialog
var _update_info: Dictionary = {}
var _update_test: = false


var auth: AuthClient
var login_layer: CanvasLayer
var _login_account: LineEdit
var _login_password: LineEdit
var _login_btn: Button
var _login_status: Label
var login_base_url: = ""
var _heartbeat_timer: Timer


var _band_active: = false
var _band_start: = Vector2.ZERO
var band_rect: Panel
var rename_dialog: ConfirmationDialog
var rename_edit: LineEdit


var _preset_cards: Array = []
var _preview_frame: = 0
var _preview_accum: = 0.0
var preview_dialog: ConfirmationDialog
var _dialog_rect: TextureRect
var _dialog_atlas: AtlasTexture
var _dialog_frames: = 1
var _dialog_key: = ""
var _dialog_cn: = ""


func _ready() -> void :
	render_mode = OS.get_cmdline_user_args().has("--previz-render")\
	or OS.get_cmdline_args().has("--write-movie")
	shots = [_make_shot("段落1")]
	_load_model_index()
	_build_world()
	var user_args: = OS.get_cmdline_user_args()
	if user_args.has("--previz-build-index"):
		_run_build_index.call_deferred()
		return
	if render_mode:
		_enter_render_mode()
		return
	get_window().title = "CineForge 白模预演 v" + APP_VERSION
	_load_settings()
	_setup_window_scale()
	_build_ui()
	_set_mode(false)
	if user_args.has("--previz-build-thumbs"):
		_run_build_thumbs.call_deferred()
	elif user_args.has("--previz-build-previews"):
		_run_build_previews.call_deferred()
	elif user_args.has("--previz-build-posesheet"):
		_run_build_posesheet.call_deferred()
	elif user_args.has("--previz-smoke"):
		_run_smoke.call_deferred()
	elif user_args.has("--previz-uishot"):
		_run_uishot.call_deferred()
	elif user_args.has("--previz-uishot-layout"):
		_run_uishot_layout.call_deferred()
	elif user_args.has("--previz-uishot-dialog"):
		_run_uishot_dialog.call_deferred()
	elif user_args.has("--previz-uishot-empty"):
		_run_uishot_empty.call_deferred()
	elif user_args.has("--previz-ffmpeg-test"):
		_run_ffmpeg_test.call_deferred()
	elif user_args.has("--previz-still-test"):
		_run_still_test.call_deferred()
	else:
		_status("项目已就绪")




func _make_shot(shot_name: String) -> Dictionary:
	return {"name": shot_name, "duration": 8.0, "cam_kf": [], "obj_kf": {}, 
		"handheld": 0.0}




const HANDHELD_POS: = 0.05
const HANDHELD_ROT: = 0.0175
func _handheld_offset(t: float, amp: float) -> Dictionary:
	var px: = sin(t * 2.3) * 0.6 + sin(t * 5.7 + 1.3) * 0.3 + sin(t * 11.0 + 2.1) * 0.12
	var py: = sin(t * 1.9 + 0.7) * 0.6 + sin(t * 6.3 + 2.4) * 0.28 + sin(t * 13.0) * 0.1
	var pz: = sin(t * 2.7 + 1.9) * 0.4 + sin(t * 4.9 + 0.5) * 0.2
	var pitch: = sin(t * 2.1 + 0.4) * 0.6 + sin(t * 7.3 + 1.1) * 0.25
	var yaw: = sin(t * 1.7 + 2.2) * 0.6 + sin(t * 5.1 + 0.9) * 0.25
	var roll: = sin(t * 1.3 + 1.5) * 0.5 + sin(t * 3.7) * 0.2
	return {
		"pos": Vector3(px, py, pz) * (amp * HANDHELD_POS), 
		"rot": Vector3(pitch, yaw, roll) * (amp * HANDHELD_ROT), 
	}


func _shot() -> Dictionary:
	return shots[cur_shot]


func _cam_kf() -> Array:
	return _shot().cam_kf


func _obj_kf() -> Dictionary:
	return _shot().obj_kf


func _duration() -> float:
	return float(_shot().duration)




func _load_model_index() -> void :
	var txt: = FileAccess.get_file_as_string("res://models_index.json")
	if txt.is_empty():
		return
	var data = JSON.parse_string(txt)
	if typeof(data) != TYPE_DICTIONARY:
		return
	model_index = data
	var scales: = {}
	for c in data.get("categories", []):
		scales[String(c.key)] = float(c.get("scale", 1.0))
	for m in data.get("models", []):
		model_lookup[String(m.id)] = {
			"entry": m, 
			"cat_scale": scales.get(String(m.cat), 1.0), 
		}


func _thumb_texture(thumb_id: String) -> Texture2D:
	var path: = "res://thumbs/%s.png" % thumb_id.replace("/", "_")
	if ResourceLoader.exists(path):
		return load(path)
	return null


func _spawn_model(entry: Dictionary) -> void :
	var info: Dictionary = model_lookup.get(String(entry.id), {})
	if info.is_empty():
		return
	_push_undo()
	var at: = _spawn_pos(10.0)
	var obj: = scene_manager.add_model(entry, float(info.cat_scale), at)
	if obj:
		scene_manager.select(obj)
		_status("已添加 " + String(obj.name))


func _spawn_primitive(kind: String) -> void :
	_push_undo()
	var obj: = scene_manager.add_primitive(kind, _spawn_pos(8.0))
	scene_manager.select(obj)
	_status("已添加 " + String(obj.name))


func _spawn_figure(body_type: String) -> void :
	_push_undo()
	var obj: = scene_manager.add_figure(_spawn_pos(8.0), body_type)
	scene_manager.select(obj)
	_status("已添加 %s(属性面板可换姿势)" % String(obj.name))



func _spawn_crowd_grid(rows: int, cols: int, spacing: float) -> void :
	_push_undo()
	var at: = _spawn_pos(9.0 + rows * spacing * 0.5)
	var members: Array = []
	for r in range(rows):
		for c in range(cols):
			members.append(scene_manager.add_figure(at + Vector3(
				(c - (cols - 1) / 2.0) * spacing, 0, 
				(r - (rows - 1) / 2.0) * spacing)))
	scene_manager.select_many(members)
	var g: = scene_manager.group_selected()
	if g:
		_crowd_counter += 1
		g.name = "群众组%d" % _crowd_counter
		scene_manager.refresh_labels()
	_status("已添加群众阵列 %d×%d(共 %d 人),已自动打组" % [rows, cols, rows * cols])


func _spawn_pos(dist: float) -> Vector3:
	var fwd: = - fly_cam.basis.z
	fwd.y = 0.0
	if fwd.length() < 0.01:
		fwd = Vector3.FORWARD
	var at: = fly_cam.global_position + fwd.normalized() * dist
	at.x = snappedf(at.x, 0.5)
	at.z = snappedf(at.z, 0.5)
	return at




func _setup_updater() -> void :
	updater = Updater.new()
	updater.app_version = APP_VERSION
	updater.manifest_url = UPDATE_MANIFEST_URL
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--previz-update-url="):
			updater.manifest_url = a.get_slice("=", 1)
	_update_test = OS.get_cmdline_user_args().has("--previz-autoupdate-test")
	add_child(updater)
	updater.status.connect( func(msg: String) -> void : _status(msg))
	updater.failed.connect( func(msg: String) -> void : _status("更新:" + msg))
	updater.download_progress.connect( func(p: float) -> void :
		_status("正在下载新版本… %d%%" % int(p)))
	updater.update_available.connect(_on_update_available)
	updater.ready_to_install.connect(_on_update_ready)
	if not updater.manifest_url.is_empty():
		updater.check( not _update_test)


func _on_update_available(info: Dictionary) -> void :
	_update_info = info
	print("UPDATE: 发现新版本 v" + String(info.version))
	if _update_test:
		updater.apply_update(info)
		return
	update_dialog.title = "发现新版本 v" + String(info.version)
	update_dialog.dialog_text = String(info.get("notes", "修复与改进"))\
	+ "\n\n当前版本 v" + APP_VERSION + " → 新版本 v" + String(info.version)
	update_dialog.get_cancel_button().visible = not bool(info.get("force", false))
	update_dialog.popup_centered()


func _on_update_ready(new_exe: String) -> void :
	print("UPDATE: 下载完成 " + new_exe)
	if updater.install(new_exe):
		await get_tree().create_timer(0.5).timeout
		get_tree().quit()


func _manual_check_update() -> void :
	if updater.manifest_url.is_empty():
		_status("当前版本未启用应用内更新")
		return
	_status("正在检查更新…")
	updater.check(false)






func _setup_auth() -> void :
	auth = AuthClient.new()
	auth.app_version = APP_VERSION
	auth.base_url = login_base_url if not login_base_url.is_empty() else CINEFORGE_BASE
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--previz-login-url="):
			auth.base_url = a.get_slice("=", 1)
	add_child(auth)
	auth.login_ok.connect(_on_login_ok)
	auth.login_failed.connect(_on_login_failed)
	auth.authed.connect(_on_authed)
	auth.need_login.connect(_on_token_rejected)
	auth.blocked.connect(_on_blocked)
	auth.need_online.connect(_on_need_online)
	_build_login_gate()
	if auth.has_token():
		_set_login_enabled(false)
		_login_status.text = "正在验证登录…"
		auth.verify.call_deferred()
	else:
		_show_login_form()



func _build_login_gate() -> void :
	login_layer = CanvasLayer.new()
	login_layer.layer = 100
	add_child(login_layer)

	var root: = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.theme = ui_theme
	login_layer.add_child(root)


	var backdrop: = ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = UITheme.FIELD
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(backdrop)

	var center: = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)

	var card: = PanelContainer.new()
	center.add_child(card)

	var box: = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	box.custom_minimum_size = Vector2(340, 0)
	card.add_child(box)

	var title: = Label.new()
	title.text = "CineForge 白模预演"
	title.theme_type_variation = "TitleLabel"
	title.add_theme_font_size_override("font_size", 22)
	box.add_child(title)

	var sub: = Label.new()
	sub.text = "开始创建你的 3D 预演项目"
	sub.theme_type_variation = "DimLabel"
	box.add_child(sub)

	box.add_child(_gap(6))

	box.add_child(_field_label("账号"))
	_login_account = LineEdit.new()
	_login_account.placeholder_text = "用户名 / 邮箱 / 手机号"
	box.add_child(_login_account)

	box.add_child(_field_label("密码"))
	_login_password = LineEdit.new()
	_login_password.placeholder_text = "账号密码"
	_login_password.secret = true
	_login_password.text_submitted.connect( func(_t: String) -> void : _do_login())
	box.add_child(_login_password)

	box.add_child(_gap(4))

	_login_btn = Button.new()
	_login_btn.text = "登录"
	_login_btn.theme_type_variation = "PrimaryButton"
	_login_btn.pressed.connect(_do_login)
	box.add_child(_login_btn)

	_login_status = Label.new()
	_login_status.theme_type_variation = "DimLabel"
	_login_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_login_status.custom_minimum_size = Vector2(340, 0)
	box.add_child(_login_status)


	var reg_btn: = Button.new()
	reg_btn.text = "无需账号即可使用"
	reg_btn.theme_type_variation = "GhostButton"
	reg_btn.add_theme_font_size_override("font_size", 11)
	reg_btn.pressed.connect( func() -> void :
		_status("当前版本无需注册或登录"))
	box.add_child(reg_btn)


func _field_label(text: String) -> Label:
	var l: = Label.new()
	l.text = text
	l.theme_type_variation = "DimLabel"
	return l


func _gap(h: int) -> Control:
	var c: = Control.new()
	c.custom_minimum_size = Vector2(0, h)
	return c


func _show_login_form() -> void :
	_set_login_enabled(true)
	_login_status.text = ""
	if _login_account:
		_login_account.grab_focus()


func _set_login_enabled(on: bool) -> void :
	if _login_account:
		_login_account.editable = on
	if _login_password:
		_login_password.editable = on
	if _login_btn:
		_login_btn.disabled = not on


func _do_login() -> void :
	var acc: = _login_account.text.strip_edges()
	var pw: = _login_password.text
	if acc.is_empty() or pw.is_empty():
		_login_error("请输入账号和密码")
		return
	_set_login_enabled(false)
	_login_status.remove_theme_color_override("font_color")
	_login_status.text = "正在登录…"
	auth.login(acc, pw)


func _login_error(msg: String) -> void :
	_login_status.text = msg
	_login_status.add_theme_color_override("font_color", Color("e5484d"))


func _on_login_ok(u: Dictionary) -> void :
	_dismiss_login_gate()
	_start_heartbeat()
	_status("已登录:" + String(u.get("nickname", "项目用户")))


func _on_login_failed(msg: String) -> void :
	_set_login_enabled(true)
	_login_error(msg)


func _on_authed(u: Dictionary, online: bool) -> void :

	_dismiss_login_gate()
	_start_heartbeat()
	if online:
		_status("欢迎回来:" + String(u.get("nickname", "项目用户")))
	else:
		_status("已进入项目工作区")


func _on_token_rejected() -> void :

	_show_login_form()
	_login_status.text = "登录已过期,请重新登录"


func _dismiss_login_gate() -> void :
	if login_layer:
		login_layer.queue_free()
		login_layer = null



func _start_heartbeat() -> void :
	if _heartbeat_timer:
		return
	_heartbeat_timer = Timer.new()
	_heartbeat_timer.wait_time = 300.0
	_heartbeat_timer.timeout.connect(_on_heartbeat_tick)
	add_child(_heartbeat_timer)
	_heartbeat_timer.start()


func _on_heartbeat_tick() -> void :
	if auth:
		auth.heartbeat()


func _stop_heartbeat() -> void :
	if _heartbeat_timer:
		_heartbeat_timer.stop()
		_heartbeat_timer.queue_free()
		_heartbeat_timer = null



func _on_blocked(msg: String) -> void :
	_stop_heartbeat()
	_show_block_screen("软件已停用", msg, false)



func _on_need_online(msg: String) -> void :
	_show_block_screen("需要联网验证", msg, true)



func _show_block_screen(title_text: String, msg: String, show_retry: bool) -> void :
	_dismiss_login_gate()
	login_layer = CanvasLayer.new()
	login_layer.layer = 100
	add_child(login_layer)
	var root: = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.theme = ui_theme
	login_layer.add_child(root)
	var backdrop: = ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = UITheme.FIELD
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(backdrop)
	var center: = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)
	var card: = PanelContainer.new()
	center.add_child(card)
	var box: = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	box.custom_minimum_size = Vector2(360, 0)
	card.add_child(box)
	var title: = Label.new()
	title.text = title_text
	title.theme_type_variation = "TitleLabel"
	title.add_theme_font_size_override("font_size", 20)
	box.add_child(title)
	var body: = Label.new()
	body.text = msg
	body.theme_type_variation = "DimLabel"
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.custom_minimum_size = Vector2(360, 0)
	box.add_child(body)
	if show_retry:
		var retry: = Button.new()
		retry.text = "重试联网"
		retry.theme_type_variation = "PrimaryButton"
		retry.pressed.connect(_on_retry_online)
		box.add_child(retry)


func _on_retry_online() -> void :
	_dismiss_login_gate()
	if auth:
		auth.verify()



func _do_logout() -> void :
	_stop_heartbeat()
	if auth:
		auth.logout()
	_dismiss_login_gate()
	_build_login_gate()
	_show_login_form()
	_status("已退出登录")




func _load_settings() -> void :
	var txt: = FileAccess.get_file_as_string(SETTINGS_PATH)
	if txt.is_empty():
		return
	var data = JSON.parse_string(txt)
	if typeof(data) == TYPE_DICTIONARY:
		ui_scale_setting = float(data.get("ui_scale", 0.0))
		recent_files = data.get("recents", [])


func _save_settings() -> void :
	var f: = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({
			"ui_scale": ui_scale_setting, 
			"recents": recent_files, 
		}))
		f.flush()


func _add_recent(path: String) -> void :
	recent_files.erase(path)
	recent_files.push_front(path)
	if recent_files.size() > 8:
		recent_files.resize(8)
	_save_settings()
	_rebuild_file_menu()


func _setup_window_scale() -> void :
	get_window().mode = Window.MODE_MAXIMIZED
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--previz-uiscale="):
			ui_scale_setting = maxf(0.0, float(a.get_slice("=", 1)))
	_apply_ui_scale()


func _apply_ui_scale() -> void :
	var factor: = ui_scale_setting
	if factor <= 0.01:
		factor = maxf(1.0, DisplayServer.screen_get_dpi() / 96.0)
	var win: = get_window()
	win.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	win.content_scale_size = Vector2i(0, 0)
	win.content_scale_factor = clampf(factor, 0.5, 3.0)




func _build_world() -> void :
	sun = DirectionalLight3D.new()
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 80.0
	add_child(sun)

	var world_env: = WorldEnvironment.new()
	env_res = Environment.new()
	env_res.background_mode = Environment.BG_COLOR
	env_res.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	world_env.environment = env_res
	add_child(world_env)
	_apply_environment()

	ground = MeshInstance3D.new()
	var plane: = PlaneMesh.new()
	plane.size = Vector2(200, 200)
	ground.mesh = plane
	var gmat: = StandardMaterial3D.new()
	gmat.albedo_color = Color("9aa094")
	ground.material_override = gmat
	add_child(ground)

	grid = _build_grid()
	add_child(grid)

	scene_manager = SceneManager.new()
	scene_manager.name = "Objects"
	add_child(scene_manager)

	fly_cam = FlyCamera.new()
	add_child(fly_cam)
	fly_cam.global_position = Vector3(10, 7, 12)
	fly_cam.look_at(Vector3.ZERO)
	fly_cam.current = true
	fly_cam.took_control.connect(_on_user_took_control)

	export_manager = ExportManager.new()
	add_child(export_manager)
	export_manager.status.connect( func(msg: String) -> void : _status(msg))
	export_manager.finished.connect(_on_export_finished)

	gizmo = TranslateGizmo.new()
	add_child(gizmo)
	scale_handle = _make_scale_handle()
	add_child(scale_handle)


	thumb_vp = SubViewport.new()
	thumb_vp.size = Vector2i(192, 108)
	thumb_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	add_child(thumb_vp)
	thumb_cam = Camera3D.new()
	thumb_cam.cull_mask = 1
	thumb_vp.add_child(thumb_cam)
	thumb_cam.current = true


const GRID_SHADER: = "shader_type spatial;\nrender_mode unshaded, cull_disabled, shadows_disabled, specular_disabled;\nuniform float fade_far = 140.0;\nvarying vec3 wpos;\nvoid vertex() { wpos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }\nfloat line_a(vec2 p, float step) {\n\tvec2 c = p / step;\n\tvec2 d = abs(fract(c - 0.5) - 0.5) / fwidth(c);\n\treturn 1.0 - min(min(d.x, d.y), 1.0);\n}\nvoid fragment() {\n\tvec2 wp = wpos.xz;\n\tfloat mn = line_a(wp, 1.0);      // 次线(每 1 米)\n\tfloat mj = line_a(wp, 5.0);      // 主线(每 5 米)\n\tfloat dist = length(wp - CAMERA_POSITION_WORLD.xz);\n\tfloat fade = 1.0 - smoothstep(fade_far * 0.35, fade_far, dist);\n\tALBEDO = mix(vec3(0.30, 0.34, 0.42), vec3(0.13, 0.17, 0.25), step(0.5, mj));\n\tALPHA = max(mn * 0.42, mj * 0.75) * fade;\n}"





















func _build_grid() -> MeshInstance3D:
	var mi: = MeshInstance3D.new()
	var plane: = PlaneMesh.new()
	plane.size = Vector2(800, 800)
	mi.mesh = plane
	mi.position.y = 0.012
	var m: = ShaderMaterial.new()
	var sh: = Shader.new()
	sh.code = GRID_SHADER
	m.shader = sh
	mi.material_override = m
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mi.layers = 2
	return mi


func _apply_environment() -> void :
	var p: Dictionary = ENV_PRESETS.get(env_preset, ENV_PRESETS.day)
	sun.rotation_degrees = Vector3(float(p.elev), sun_azimuth, 0)
	sun.light_color = p.sun
	sun.light_energy = float(p.energy)
	env_res.background_color = p.sky
	env_res.ambient_light_color = p.amb
	env_res.ambient_light_energy = float(p.amb_e)


func _set_env_preset(key: String) -> void :
	env_preset = key
	_apply_environment()
	_sync_env_chips()
	_status("时段:" + String(ENV_PRESETS[key].cn))


func _sync_env_chips() -> void :
	for k in _env_chips:
		(_env_chips[k] as Button).set_pressed_no_signal(k == env_preset)
	if _azimuth_slider:
		_azimuth_slider.set_value_no_signal(sun_azimuth)


func _on_user_took_control() -> void :
	if playing:
		playing = false
		playing_all = false
		_sync_play_btn()




func _enter_render_mode() -> void :
	print("RENDER: 进入渲染模式")
	grid.visible = false
	fly_cam.input_enabled = false
	var txt: = FileAccess.get_file_as_string(JOB_PATH)
	var job = JSON.parse_string(txt) if not txt.is_empty() else null
	if typeof(job) != TYPE_DICTIONARY or not _load_project_data(job.get("project", {})):
		push_error("渲染模式:任务文件无效")
		get_tree().quit(1)
		return
	cur_shot = clampi(int(job.get("shot", 0)), 0, shots.size() - 1)
	print("RENDER: 段落 %d/%d keys=%d dur=%.1f 标注入片=%s" % [
		cur_shot + 1, shots.size(), _cam_kf().size(), _duration(), str(labels_burn)])
	scene_manager.set_labels_visible(labels_burn)
	fly_cam.projection = Camera3D.PROJECTION_PERSPECTIVE
	playhead = 0.0
	playing = true
	_apply_at(0.0)




func _process(delta: float) -> void :
	if not render_mode:
		_update_gizmo()
		_update_motion_blur(delta)
		_fps_timer += delta
		if fps_label and _fps_timer > 0.25:
			_fps_timer = 0.0
			fps_label.text = "%d FPS" % int(Engine.get_frames_per_second())

		if shoot_mode:
			_preview_accum += delta
			if _preview_accum > 0.14:
				_preview_accum = 0.0
				_preview_frame += 1
				for c in _preset_cards:
					if c.hovered:
						var at: AtlasTexture = c.atlas
						at.region = Rect2(
							(_preview_frame % int(c.frames)) * 160.0, 0, 160, 90)
				if preview_dialog and preview_dialog.visible and _dialog_atlas:
					_dialog_atlas.region = Rect2(
						(_preview_frame % _dialog_frames) * 160.0, 0, 160, 90)
	if not playing:
		return
	var prev: = playhead
	var end: = _duration() if render_mode else _preview_end()
	playhead += delta
	if not render_mode and pause_key_check and pause_key_check.button_pressed:
		for k in _cam_kf():
			var kt: = float(k.t)
			if kt > prev + 0.001 and kt <= playhead and kt < end - 0.001:
				playhead = kt
				playing = false
				break
	if playing and playhead >= end:
		if render_mode:
			playhead = end
			_apply_at(playhead)
			get_tree().quit()
			return

		if playing_all and cur_shot < shots.size() - 1:
			_goto_shot(cur_shot + 1, true)
		elif loop_check and loop_check.button_pressed:
			if playing_all and shots.size() > 1:
				_goto_shot(0, true)
			playhead = 0.0
		else:

			playing = false
			playing_all = false
			playhead = end
	_apply_at(playhead)
	_sync_play_btn()
	if timeline:
		timeline.playhead = playhead
	_update_time_label()



func _preview_end() -> float:
	var last: = 0.0
	var ck: = _cam_kf()
	if not ck.is_empty():
		last = maxf(last, float(ck[-1].t))
	for oname in _obj_kf():
		var track: Array = _obj_kf()[oname]
		if not track.is_empty():
			last = maxf(last, float(track[-1].t))
	if last > 0.01:
		return minf(_duration(), last)
	return _duration()


func _apply_at(t: float) -> void :
	_apply_camera_at(t)
	_apply_objects_at(t)


func _apply_camera_at(t: float) -> void :
	var ck: = _cam_kf()
	if ck.is_empty():
		return
	var s: = _sample_keys(ck, t)
	var pos: Vector3 = s.pos
	var b: = Basis(s.rot as Quaternion)
	var hh: = float(_shot().get("handheld", 0.0))
	if hh > 0.001 and (playing or render_mode):
		var o: = _handheld_offset(t, hh)
		pos += b * (o.pos as Vector3)
		b = b * Basis.from_euler(o.rot as Vector3)
	fly_cam.apply_animated_pose(
		Transform3D(b, pos), 
		float(s.get("fov", 60.0)), float(s.get("shift", 0.0)))
	if fov_slider:
		fov_slider.set_value_no_signal(fly_cam.fov_deg)
		_update_fov_label()
	_sync_view_buttons()


func _apply_objects_at(t: float) -> void :
	var tracks: = _obj_kf()
	for oname in tracks:
		var track: Array = tracks[oname]
		if track.is_empty():
			continue
		var node: = scene_manager.get_node_or_null(NodePath(String(oname)))
		if node == null:
			continue

		if String(node.get_meta("kind", "")) == "figure":
			_apply_figure_pose_at(node, track, t)
		var s: = _sample_keys(track, t)
		node.position = s.pos
		node.quaternion = s.rot




func _apply_figure_pose_at(node: Node3D, keys: Array, t: float) -> void :
	var n: = keys.size()
	if n == 0:
		return
	var pa: = ""
	var pb: = ""
	var u: = 0.0
	if n == 1 or t <= float(keys[0].t):
		pa = String((keys[0] as Dictionary).get("pose", ""))
		pb = pa
	elif t >= float(keys[n - 1].t):
		pa = String((keys[n - 1] as Dictionary).get("pose", ""))
		pb = pa
	else:
		var i: = 0
		while i < n - 2 and t > float(keys[i + 1].t):
			i += 1
		var a: Dictionary = keys[i]
		var b: Dictionary = keys[i + 1]
		var seg: = maxf(float(b.t) - float(a.t), 0.0001)
		var uu: = (t - float(a.t)) / seg
		u = uu * uu * (3.0 - 2.0 * uu)
		pa = String(a.get("pose", ""))
		pb = String(b.get("pose", ""))
	if pa == "" and pb == "":
		return
	if pa == "":
		pa = pb
	if pb == "":
		pb = pa
	FigureLib.blend_pose(node, pa, pb, u)
	node.set_meta("figure_pose", pb if u >= 0.5 else pa)




static func _mono_axis(v0: float, v1: float, v2: float, v3: float, 
		h00: float, h10: float, h01: float, h11: float) -> float:
	var m1: = (v2 - v0) * 0.5
	var m2: = (v3 - v1) * 0.5
	if (v1 - v0) * (v2 - v1) <= 0.0:
		m1 = 0.0
	if (v2 - v1) * (v3 - v2) <= 0.0:
		m2 = 0.0
	return h00 * v1 + h10 * m1 + h01 * v2 + h11 * m2


func _sample_keys(keys: Array, t: float) -> Dictionary:
	var n: = keys.size()
	if n == 1 or t <= float(keys[0].t):
		return keys[0]
	if t >= float(keys[n - 1].t):
		return keys[n - 1]
	var i: = 0
	while i < n - 2 and t > float(keys[i + 1].t):
		i += 1
	var a: Dictionary = keys[i]
	var b: Dictionary = keys[i + 1]
	var seg: = maxf(float(b.t) - float(a.t), 0.0001)
	var u: = (t - float(a.t)) / seg
	var su: = u * u * (3.0 - 2.0 * u)


	var p0: Vector3 = keys[maxi(i - 1, 0)].pos
	var p1: Vector3 = a.pos
	var p2: Vector3 = b.pos
	var p3: Vector3 = keys[mini(i + 2, n - 1)].pos
	var u2: = u * u
	var u3: = u2 * u
	var h00: = 2.0 * u3 - 3.0 * u2 + 1.0
	var h10: = u3 - 2.0 * u2 + u
	var h01: = -2.0 * u3 + 3.0 * u2
	var h11: = u3 - u2
	var pos: = Vector3(
		_mono_axis(p0.x, p1.x, p2.x, p3.x, h00, h10, h01, h11), 
		_mono_axis(p0.y, p1.y, p2.y, p3.y, h00, h10, h01, h11), 
		_mono_axis(p0.z, p1.z, p2.z, p3.z, h00, h10, h01, h11))


	var pre_rot: Quaternion = keys[maxi(i - 1, 0)].rot
	var post_rot: Quaternion = keys[mini(i + 2, n - 1)].rot
	var out: = {
		"pos": pos, 
		"rot": (a.rot as Quaternion).spherical_cubic_interpolate(
			b.rot as Quaternion, pre_rot, post_rot, u), 
	}
	if a.has("fov"):
		out["fov"] = lerpf(float(a.fov), float(b.get("fov", a.fov)), su)
	if a.has("shift") or b.has("shift"):
		out["shift"] = lerpf(float(a.get("shift", 0.0)), float(b.get("shift", 0.0)), su)
	return out




func _insert_key(keys: Array, key: Dictionary) -> bool:
	for i in range(keys.size()):
		if absf(float(keys[i].t) - float(key.t)) < 0.05:
			keys[i] = key
			return false
	keys.append(key)
	keys.sort_custom( func(x, y): return float(x.t) < float(y.t))
	return true


func _add_camera_keyframe() -> void :
	if not shoot_mode:
		_status("请先切到「拍摄模式」再打关键帧")
		return
	var added: = _insert_key(_cam_kf(), {
		"t": playhead, 
		"pos": fly_cam.global_position, 
		"rot": fly_cam.quaternion, 
		"fov": fly_cam.fov_deg, 
		"shift": fly_cam.look_angle if fly_cam.two_point else 0.0, 
	})
	_extend_duration_to(playhead)
	_status(("已打相机关键帧" if added else "已更新相机关键帧") + " @ %.2fs" % playhead)
	_after_keys_changed()


func _add_object_keyframe() -> void :
	if not shoot_mode:
		_status("请先切到「拍摄模式」再打关键帧")
		return
	var obj: = scene_manager.selected
	if obj == null:
		_status("先左键选中一个物体,再按 J 打物体关键帧")
		return
	var oname: = String(obj.name)
	var tracks: = _obj_kf()
	if not tracks.has(oname):
		tracks[oname] = []
	var added: = _insert_key(tracks[oname], {
		"t": playhead, 
		"pos": obj.position, 
		"rot": obj.quaternion, 
	})
	_extend_duration_to(playhead)
	_status(("已打物体关键帧:" if added else "已更新物体关键帧:") + oname + " @ %.2fs" % playhead)
	_after_keys_changed()



func _after_keys_changed() -> void :
	_refresh_tracks()
	_refresh_clip_strip()
	_capture_shot_thumb.call_deferred()


func _extend_duration_to(t: float) -> void :
	if t > _duration():
		_shot()["duration"] = snappedf(t, 0.5)
		_sync_shot_ui()



func _last_key_time() -> float:
	var last: = 0.0
	var ck: = _cam_kf()
	if not ck.is_empty():
		last = maxf(last, float(ck[-1].t))
	for oname in _obj_kf():
		var track: Array = _obj_kf()[oname]
		if not track.is_empty():
			last = maxf(last, float(track[-1].t))
	return last



func _scale_keytimes(f: float) -> void :
	for k in _cam_kf():
		k["t"] = float(k.t) * f
	for oname in _obj_kf():
		for k in _obj_kf()[oname]:
			k["t"] = float(k.t) * f
	for wp in _wp_stack():
		wp["t"] = float(wp.t) * f




func _set_total_duration(v: float) -> void :
	var stack: = _wp_stack()
	if stack.size() >= 2:
		_set_waypoint_time(stack.size() - 1, v, null)
		_refresh_wp_strip()
	else:
		_set_shot_duration_scaled(v)



func _set_shot_duration_scaled(v: float) -> void :
	var last: = _last_key_time()
	if last > 0.01 and v > 0.0:
		_scale_keytimes(v / last)
	_shot()["duration"] = v
	playhead = clampf(playhead, 0.0, v)
	if timeline:
		timeline.duration = v
	_after_keys_changed()
	_sync_shot_ui()
	_update_time_label()


func _delete_key_near(keys: Array, label: String) -> void :
	var best: = -1
	var best_d: = 0.2
	for i in range(keys.size()):
		var d: = absf(float(keys[i].t) - playhead)
		if d < best_d:
			best_d = d
			best = i
	if best >= 0:
		keys.remove_at(best)
		_status("已删除%s关键帧(剩 %d 个)" % [label, keys.size()])
	else:
		_status("播放头附近没有%s关键帧" % label)
	_after_keys_changed()


func _has_any_keys() -> bool:
	if not _cam_kf().is_empty():
		return true
	for oname in _obj_kf():
		if not (_obj_kf()[oname] as Array).is_empty():
			return true
	return false


func _toggle_play() -> void :
	if not shoot_mode:
		return
	if not _has_any_keys():
		_status("还没有关键帧:按 K 打相机帧,或选中物体按 J 打物体帧")
		return

	if not playing and playhead >= _preview_end() - 0.001:
		playhead = 0.0
	playing = not playing
	playing_all = playing
	_sync_play_btn()


func _jump_to_key(dirn: int) -> void :
	var ck: = _cam_kf()
	if ck.is_empty():
		return
	var target: = playhead
	if dirn > 0:
		for k in ck:
			if float(k.t) > playhead + 0.001:
				target = float(k.t)
				break
	else:
		for i in range(ck.size() - 1, -1, -1):
			if float(ck[i].t) < playhead - 0.001:
				target = float(ck[i].t)
				break
		if target == playhead:
			target = 0.0
	playhead = target
	playing = false
	_sync_play_btn()
	_apply_at(playhead)
	timeline.playhead = playhead
	_update_time_label()


func _sync_play_btn() -> void :
	if play_btn:
		play_btn.text = "⏸" if playing else "▶"


func _update_time_label() -> void :
	if time_label:
		time_label.text = "%05.2f / %05.2f" % [playhead, _duration()]





func _wp_stack() -> Array:
	var s: = _shot()
	if not s.has("wp"):
		s["wp"] = []
	return s.wp


func _capture_object_states() -> Dictionary:
	var out: = {}
	for obj in scene_manager.list_objects():
		var st: = {
			"pos": (obj as Node3D).position, 
			"rot": (obj as Node3D).quaternion, 
		}
		if String(obj.get_meta("kind", "")) == "figure":
			st["pose"] = String(obj.get_meta("figure_pose", ""))
		out[String(obj.name)] = st
	return out



func _record_waypoint() -> void :
	if not shoot_mode:
		return
	var ck: = _cam_kf()
	var cur_objs: = _capture_object_states()
	var prev_t: = 0.0
	var prev_cam: = fly_cam.global_position
	var prev_objs: Dictionary = {}
	var has_prev: = false
	if not _wp_stack().is_empty():
		var top: Dictionary = _wp_stack()[-1]
		prev_t = float(top.t)
		prev_cam = top.cam_pos
		prev_objs = top.objs
		has_prev = true
	elif not ck.is_empty():

		var last: Dictionary = ck[-1]
		prev_t = float(last.t)
		prev_cam = last.pos
		has_prev = true

	var move_dist: = (fly_cam.global_position - prev_cam).length()
	for oname in cur_objs:
		if prev_objs.has(oname):
			var d: float = ((cur_objs[oname].pos as Vector3)
				- (prev_objs[oname].pos as Vector3)).length()
			move_dist = maxf(move_dist, d)
	var new_t: = prev_t + clampf(move_dist / 3.5, 1.5, 4.0) if has_prev else 0.0

	playhead = new_t
	_insert_key(ck, {
		"t": new_t, 
		"pos": fly_cam.global_position, 
		"rot": fly_cam.quaternion, 
		"fov": fly_cam.fov_deg, 
		"shift": fly_cam.look_angle if fly_cam.two_point else 0.0, 
	})

	var moved: = 0
	if has_prev and not prev_objs.is_empty():
		var tracks: = _obj_kf()
		for oname in cur_objs:
			if not prev_objs.has(oname):
				continue
			var old: Dictionary = prev_objs[oname]
			var now: Dictionary = cur_objs[oname]
			var pos_changed: = ((now.pos as Vector3) - (old.pos as Vector3)).length() > 0.01
			var rot_changed: = (now.rot as Quaternion).angle_to(old.rot) > 0.01
			var pose_changed: = String(now.get("pose", "")) != String(old.get("pose", ""))
			if pos_changed or rot_changed or pose_changed:
				if not tracks.has(oname):
					tracks[oname] = []
				var track: Array = tracks[oname]

				_insert_key(track, {"t": prev_t, "pos": old.pos, "rot": old.rot, 
					"pose": String(old.get("pose", ""))})
				_insert_key(track, {"t": new_t, "pos": now.pos, "rot": now.rot, 
					"pose": String(now.get("pose", ""))})
				moved += 1
	_extend_duration_to(new_t)
	var wp: = {"t": new_t, "cam_pos": fly_cam.global_position, "objs": cur_objs}
	_wp_stack().append(wp)
	_after_keys_changed()
	_sync_auto_count()
	_capture_wp_thumb.call_deferred(wp)
	var msg: = "已记录第 %d 个机位点 @ %.1fs" % [_wp_stack().size(), new_t]
	if moved > 0:
		msg += "(含 %d 个物体的移动)" % moved
	if _wp_stack().size() == 1:
		msg += " · 移动相机/物体后再按 K 记下一个"
	_status(msg)


func _remove_keys_at(keys: Array, t: float) -> void :
	for i in range(keys.size() - 1, -1, -1):
		if absf(float(keys[i].t) - t) < 0.05:
			keys.remove_at(i)


func _undo_waypoint() -> void :
	if _wp_stack().is_empty():
		_status("没有可撤销的记录点")
		return
	var top: Dictionary = _wp_stack().pop_back()
	_remove_keys_at(_cam_kf(), float(top.t))


	_rebuild_obj_kf_from_waypoints()
	if not _wp_stack().is_empty():
		var last: Dictionary = _wp_stack()[-1]
		playhead = float(last.t)
		_apply_at(playhead)
		_apply_waypoint_snapshot(last)
	else:
		playhead = 0.0
		_apply_at(0.0)
	_after_keys_changed()
	_sync_auto_count()
	_refresh_wp_strip()
	_status("已撤销,剩 %d 个记录点" % _wp_stack().size())



func _delete_waypoint(idx: int) -> void :
	var stack: = _wp_stack()
	if idx < 0 or idx >= stack.size():
		return
	var tt: = float(stack[idx].t)
	stack.remove_at(idx)
	_remove_keys_at(_cam_kf(), tt)
	_rebuild_obj_kf_from_waypoints()
	if not stack.is_empty():
		var ni: = clampi(idx - 1, 0, stack.size() - 1)
		playhead = float(stack[ni].t)
		_apply_at(playhead)
		_apply_waypoint_snapshot(stack[ni])
	else:
		playhead = 0.0
		_apply_at(0.0)
	_after_keys_changed()
	_sync_auto_count()
	_refresh_wp_strip()
	_status("已删除 点%d,剩 %d 个机位点" % [idx + 1, stack.size()])




func _apply_waypoint_snapshot(wp: Dictionary) -> void :
	var objs: Dictionary = wp.get("objs", {})
	for oname in objs:
		var node: = scene_manager.get_node_or_null(NodePath(String(oname)))
		if node == null or not is_instance_valid(node):
			continue
		var st: Dictionary = objs[oname]
		if String(node.get_meta("kind", "")) == "figure":
			var pose: = String(st.get("pose", ""))
			if pose != "":
				FigureLib.apply_pose(node, pose)
				node.set_meta("figure_pose", pose)
		node.position = st.pos
		node.quaternion = st.rot
	scene_manager.refresh_labels()
	_refresh_inspector()




func _update_waypoint(idx: int) -> void :
	var stack: = _wp_stack()
	if idx < 0 or idx >= stack.size():
		return
	var wp: Dictionary = stack[idx]
	var t: = float(wp.t)

	var ck: = _cam_kf()
	for j in range(ck.size()):
		if absf(float(ck[j].t) - t) < 0.001:
			ck[j]["pos"] = fly_cam.global_position
			ck[j]["rot"] = fly_cam.quaternion
			ck[j]["fov"] = fly_cam.fov_deg
			ck[j]["shift"] = fly_cam.look_angle if fly_cam.two_point else 0.0
			break



	wp["cam_pos"] = fly_cam.global_position
	wp["objs"] = _capture_object_states()
	_rebuild_obj_kf_from_waypoints()
	_after_keys_changed()
	_capture_wp_thumb.call_deferred(wp)
	_status("已用当前机位更新 点%d" % (idx + 1))




func _set_waypoint_time(i: int, requested: float, spin: SpinBox) -> void :
	var stack: = _wp_stack()
	if i < 0 or i >= stack.size():
		return
	var lo: = 0.0
	if i > 0:
		lo = float(stack[i - 1].t) + 0.05
	var hi: = 9999.0
	if i < stack.size() - 1:
		hi = float(stack[i + 1].t) - 0.05
	var new_t: = clampf(requested, lo, hi)
	var old_t: = float(stack[i].t)
	if absf(new_t - old_t) > 0.0005:
		stack[i]["t"] = new_t
		_retime_keys(_cam_kf(), old_t, new_t)
		for oname in _obj_kf():
			_retime_keys(_obj_kf()[oname], old_t, new_t)
		_shot()["duration"] = maxf(_last_key_time(), 0.5)
		_refresh_tracks()
		if timeline:
			timeline.duration = _duration()
		if auto_dur_spin:
			auto_dur_spin.set_value_no_signal(_duration())
		playhead = clampf(playhead, 0.0, _duration())
		_update_time_label()
		_capture_shot_thumb.call_deferred()
		_status("点%d 时刻改为 %.1fs" % [i + 1, new_t])
	if spin and absf(spin.value - new_t) > 0.0005:
		spin.set_value_no_signal(new_t)



func _retime_keys(keys: Array, old_t: float, new_t: float) -> void :
	for k in keys:
		if absf(float(k.t) - old_t) < 0.001:
			k["t"] = new_t
	keys.sort_custom( func(a, b) -> bool: return float(a.t) < float(b.t))



func _wp_drag_data(_at: Vector2, from_idx: int) -> Variant:
	var prev: = Label.new()
	prev.text = "  ↔ 点%d  " % (from_idx + 1)
	prev.theme = ui_theme
	wp_strip.set_drag_preview(prev)
	return {"kind": "wp", "from": from_idx}


func _wp_can_drop(_at: Vector2, data: Variant, _to_idx: int) -> bool:
	return typeof(data) == TYPE_DICTIONARY and String((data as Dictionary).get("kind", "")) == "wp"


func _wp_drop(_at: Vector2, data: Variant, to_idx: int) -> void :
	_move_waypoint(int((data as Dictionary).get("from", -1)), to_idx)


func _move_waypoint(from: int, to: int) -> void :
	var stack: = _wp_stack()
	var ck: = _cam_kf()
	if from < 0 or from >= stack.size() or from == to:
		return
	if ck.size() != stack.size():
		return

	var contents: Array = []
	for i in range(stack.size()):
		contents.append({
			"pos": ck[i].pos, "rot": ck[i].rot, 
			"fov": float(ck[i].get("fov", 60.0)), "shift": float(ck[i].get("shift", 0.0)), 
			"objs": stack[i].objs, "cam_pos": stack[i].cam_pos, 
			"thumb": stack[i].get("thumb", null)})
	var moved = contents[from]
	contents.remove_at(from)
	contents.insert(clampi(to, 0, contents.size()), moved)
	for i in range(stack.size()):
		var c: Dictionary = contents[i]
		ck[i]["pos"] = c.pos
		ck[i]["rot"] = c.rot
		ck[i]["fov"] = c.fov
		ck[i]["shift"] = c.shift
		stack[i]["objs"] = c.objs
		stack[i]["cam_pos"] = c.cam_pos
		if c.thumb != null:
			stack[i]["thumb"] = c.thumb
		else:
			stack[i].erase("thumb")
	_rebuild_obj_kf_from_waypoints()
	_after_keys_changed()
	_refresh_wp_strip()
	_status("已调整机位点顺序")



func _rebuild_obj_kf_from_waypoints() -> void :
	var tracks: = _obj_kf()
	tracks.clear()
	var stack: = _wp_stack()
	for i in range(1, stack.size()):
		var prev: Dictionary = stack[i - 1].objs
		var cur: Dictionary = stack[i].objs
		var pt: = float(stack[i - 1].t)
		var nt: = float(stack[i].t)
		for oname in cur:
			if not prev.has(oname):
				continue
			var old: Dictionary = prev[oname]
			var now: Dictionary = cur[oname]
			var moved_pos: = ((now.pos as Vector3) - (old.pos as Vector3)).length() > 0.01
			var moved_rot: = (now.rot as Quaternion).angle_to(old.rot as Quaternion) > 0.01
			var moved_pose: = String(now.get("pose", "")) != String(old.get("pose", ""))
			if moved_pos or moved_rot or moved_pose:
				if not tracks.has(oname):
					tracks[oname] = []
				_insert_key(tracks[oname], {"t": pt, "pos": old.pos, "rot": old.rot, 
					"pose": String(old.get("pose", ""))})
				_insert_key(tracks[oname], {"t": nt, "pos": now.pos, "rot": now.rot, 
					"pose": String(now.get("pose", ""))})


func _clear_waypoints() -> void :
	_cam_kf().clear()
	_obj_kf().clear()
	_wp_stack().clear()
	playhead = 0.0
	playing = false
	_sync_play_btn()
	_after_keys_changed()
	_sync_auto_count()
	_refresh_wp_strip()
	_status("已清空本段全部记录,重新开始")


func _sync_auto_count() -> void :
	if auto_count_label:
		auto_count_label.text = "已记 %d 点" % _wp_stack().size()



func _capture_wp_thumb(wp: Dictionary) -> void :
	if thumb_vp == null:
		return
	while _thumb_busy:
		await get_tree().process_frame
	_thumb_busy = true
	thumb_cam.global_transform = fly_cam.global_transform

	if fly_cam.projection == Camera3D.PROJECTION_ORTHOGONAL:
		thumb_cam.projection = Camera3D.PROJECTION_ORTHOGONAL
		thumb_cam.size = fly_cam.size
	elif fly_cam.two_point:
		var near_h: = 2.0 * FlyCamera.NEAR * tan(deg_to_rad(fly_cam.fov_deg) * 0.5)
		thumb_cam.set_frustum(near_h, 
			Vector2(0.0, FlyCamera.NEAR * tan(fly_cam.look_angle)), 
			FlyCamera.NEAR, FlyCamera.FAR)
	else:
		thumb_cam.set_perspective(fly_cam.fov_deg, FlyCamera.NEAR, FlyCamera.FAR)
	thumb_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	wp["thumb"] = ImageTexture.create_from_image(thumb_vp.get_texture().get_image())
	_thumb_busy = false
	_refresh_wp_strip()




func _regen_wp_thumbs() -> void :
	if playing or render_mode or thumb_vp == null:
		return
	var stack: = _wp_stack()
	var ck: = _cam_kf()

	if stack.is_empty() and auto_mode and not ck.is_empty() and ck.size() <= 60:
		for k in ck:
			stack.append({"t": float(k.t), "cam_pos": (k.pos as Vector3), "objs": {}})
		_sync_auto_count()
		_refresh_wp_strip()
	var todo: = []
	for wp in stack:
		if not (wp as Dictionary).has("thumb") or (wp.get("objs", {}) as Dictionary).is_empty():
			todo.append(wp)
	if todo.is_empty():
		return
	var saved: = playhead
	for wp in todo:
		_apply_at(float(wp.t))
		if (wp.get("objs", {}) as Dictionary).is_empty():
			wp["objs"] = _capture_object_states()
		await _capture_wp_thumb(wp)
	_apply_at(saved)
	_update_time_label()



func _refresh_wp_strip() -> void :
	if not wp_strip:
		return
	for c in wp_strip.get_children():
		wp_strip.remove_child(c)
		c.queue_free()
	var stack: = _wp_stack()
	for i in range(stack.size()):
		var wp: Dictionary = stack[i]
		var idx: = i
		var slot: = VBoxContainer.new()
		slot.add_theme_constant_override("separation", 2)

		var card_wrap: = Control.new()
		card_wrap.custom_minimum_size = Vector2(118, 60)
		var card: = Button.new()
		card.theme_type_variation = "AssetCard"
		card.focus_mode = Control.FOCUS_NONE
		card.set_anchors_preset(Control.PRESET_FULL_RECT)
		card.text = "点%d" % (i + 1)
		card.clip_text = true
		card.alignment = HORIZONTAL_ALIGNMENT_CENTER
		if wp.has("thumb"):
			card.icon = wp.thumb
			card.expand_icon = true
			card.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			card.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		card.pressed.connect( func() -> void :

			var stk: = _wp_stack()
			if idx >= stk.size():
				return
			var ct: = float(stk[idx].t)
			playhead = ct
			playing = false
			_sync_play_btn()
			_apply_at(ct)
			_update_time_label()
			_status("已跳到 点%d 的画面" % (idx + 1)))
		card.tooltip_text = "点击跳到该机位 · 拖动可调整顺序(时间槽不变,只换先后)"
		card.set_drag_forwarding(
			_wp_drag_data.bind(idx), 
			_wp_can_drop.bind(idx), 
			_wp_drop.bind(idx))
		card_wrap.add_child(card)
		var upd: = Button.new()
		upd.text = "↻"
		upd.theme_type_variation = "PrimaryButton"
		upd.focus_mode = Control.FOCUS_NONE
		upd.tooltip_text = "用当前机位更新这个点(保留时间,只换角度/位置)"
		upd.custom_minimum_size = Vector2(26, 26)
		upd.anchor_left = 1.0
		upd.anchor_right = 1.0
		upd.offset_left = -29.0
		upd.offset_top = 3.0
		upd.offset_right = -3.0
		upd.offset_bottom = 29.0
		upd.pressed.connect( func() -> void : _update_waypoint(idx))
		card_wrap.add_child(upd)

		var del: = Button.new()
		del.text = "✕"
		del.theme_type_variation = "DangerChip"
		del.focus_mode = Control.FOCUS_NONE
		del.tooltip_text = "删除这个机位点"
		del.custom_minimum_size = Vector2(22, 22)
		del.offset_left = 3.0
		del.offset_top = 3.0
		del.offset_right = 25.0
		del.offset_bottom = 25.0
		del.pressed.connect( func() -> void : _delete_waypoint(idx))
		card_wrap.add_child(del)
		slot.add_child(card_wrap)

		var t_spin: = SpinBox.new()
		t_spin.min_value = 0.0
		t_spin.max_value = 120.0
		t_spin.step = 0.1
		t_spin.update_on_text_changed = true
		t_spin.value = float(wp.t)
		t_spin.suffix = "s"
		t_spin.custom_minimum_size = Vector2(118, 0)
		t_spin.tooltip_text = "机位点时刻(可手动改;会保持前后顺序)"

		t_spin.value_changed.connect( func(v: float) -> void :
			_set_waypoint_time(idx, v, null))
		var t_le: = t_spin.get_line_edit()
		if t_le:
			t_le.focus_exited.connect( func() -> void :
				if idx < _wp_stack().size():
					t_spin.set_value_no_signal(float(_wp_stack()[idx].t)))
		slot.add_child(t_spin)
		wp_strip.add_child(slot)

	if wp_scroll:
		wp_scroll.visible = auto_mode and not stack.is_empty()
	if bottom_card:
		_sync_bottom_height.call_deferred()



func _set_track_mode(auto: bool) -> void :
	auto_mode = auto
	if auto_row:
		auto_row.visible = auto
		manual_row.visible = not auto
		timeline.visible = not auto
		wp_scroll.visible = auto
		track_mode_auto_btn.set_pressed_no_signal(auto)
		track_mode_manual_btn.set_pressed_no_signal( not auto)
		_refresh_tracks()
	if auto:
		_sync_auto_count()
		_refresh_wp_strip()
		_status("自动版:飞好机位(可顺手挪物体)按 K 记录,自动串联成运镜")
	else:
		_status("手动版:时间轴精细控制,K 相机帧 · J 物体帧")




func _scene_center() -> Vector3:
	var objs: = scene_manager.list_objects()
	if objs.is_empty():
		return Vector3.ZERO
	var c: = Vector3.ZERO
	for o in objs:
		c += (o as Node3D).global_position
	return c / objs.size()



func _pk(arr: Array, t: float, pos: Vector3, look: Vector3, 
		fov_v: float, roll: = 0.0) -> void :
	var dir: = look - pos
	if dir.length() < 0.01:
		dir = Vector3.FORWARD
	var b: = Basis.looking_at(dir.normalized(), Vector3.UP)
	if absf(roll) > 0.0001:
		b = b * Basis(Vector3(0, 0, 1), roll)
	arr.append({
		"t": t, "pos": pos, 
		"rot": b.get_rotation_quaternion(), 
		"fov": fov_v, "shift": 0.0, 
	})



func _generate_preset_keys(key: String, ctx: Dictionary) -> Array:
	var target: Vector3 = ctx.target
	var cur: Vector3 = ctx.cur
	var fov0: float = ctx.fov0
	var D: float = ctx.D
	var flat: = Vector2(cur.x - target.x, cur.z - target.z)
	var rh: = maxf(flat.length(), 4.0)
	var a0: = atan2(flat.x, flat.y)
	var h: = maxf(cur.y, target.y + 0.5)
	var fwd: = Vector3(sin(a0), 0, cos(a0))
	var dirc: = (cur - target).normalized()
	var right: = fwd.cross(Vector3.UP).normalized()
	var ck: Array = []
	match key:
		"static_shot":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + Vector3(0, 0.001, 0), target, fov0)
		"push":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, target + dirc * rh * 0.35 + Vector3.UP * 0.2, target, fov0)
		"pull":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, target + dirc * rh * 2.4 + Vector3.UP * rh * 0.5, target, fov0)
		"rise":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + Vector3.UP * rh * 0.9, target, fov0)
		"lower":
			_pk(ck, 0.0, cur, target, fov0)
			var low: = cur
			low.y = maxf(0.6, target.y * 0.5)
			_pk(ck, D, low, target, fov0)
		"truck_left":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur - right * rh * 1.0, target, fov0)
		"truck_right":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + right * rh * 1.0, target, fov0)
		"push_rise":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, target + dirc * rh * 0.45 + Vector3.UP * rh * 0.55, target, fov0)
		"pull_rise":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + dirc * rh * 1.2 + Vector3.UP * rh * 0.6, target, fov0)
		"pan_up":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + Vector3(0, 0.001, 0), 
				target + Vector3.UP * rh * 1.2, fov0)
		"pan_down":
			_pk(ck, 0.0, cur, target + Vector3.UP * rh * 1.2, fov0)
			_pk(ck, D, cur + Vector3(0, 0.001, 0), 
				target - Vector3.UP * rh * 0.3, fov0)
		"pan_left":
			var tt: = target - cur
			_pk(ck, 0.0, cur, cur + tt.rotated(Vector3.UP, -0.55), fov0)
			_pk(ck, D, cur + Vector3(0, 0.001, 0), 
				cur + tt.rotated(Vector3.UP, 0.55), fov0)
		"pan_right":
			var tt2: = target - cur
			_pk(ck, 0.0, cur, cur + tt2.rotated(Vector3.UP, 0.55), fov0)
			_pk(ck, D, cur + Vector3(0, 0.001, 0), 
				cur + tt2.rotated(Vector3.UP, -0.55), fov0)
		"zoom_in":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + Vector3(0, 0.001, 0), target, maxf(fov0 * 0.42, 16.0))
		"zoom_out":
			_pk(ck, 0.0, cur, target, maxf(fov0 * 0.42, 16.0))
			_pk(ck, D, cur + Vector3(0, 0.001, 0), target, fov0)
		"dolly_zoom":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + dirc * rh * 0.7, target, maxf(fov0 * 0.45, 16.0))
		"orbit90", "orbit180", "orbit_rise", "orbit_fall", "orbit_push", \
		"dream_orbit", "bullet_time", "spiral":
			var sweep: = PI * 0.5
			var rise: = 0.0
			var rad_end: = 1.0
			var n: = 5
			var fov_end: = fov0
			match key:
				"orbit180":
					sweep = PI
				"orbit_rise":
					rise = rh * 0.7
				"orbit_fall":
					rise = - minf(h - 0.7, rh * 0.7)
				"orbit_push":
					rad_end = 0.5
				"dream_orbit":
					sweep = PI * 0.66
					rise = rh * 0.25
					fov_end = fov0 * 0.85
				"bullet_time":
					sweep = PI * 0.85
					n = 6
				"spiral":
					sweep = PI * 1.5
					rise = rh * 0.9
					n = 6
			for i in range(n):
				var f: = float(i) / (n - 1)
				var a: = a0 + sweep * f
				var r: = rh * lerpf(1.0, rad_end, f)
				var pos: = target + Vector3(sin(a) * r, 0, cos(a) * r)
				pos.y = h + rise * f
				_pk(ck, D * f, pos, target, lerpf(fov0, fov_end, f))
		"follow_left", "follow_right":
			var fsign: = 0.5 if key == "follow_right" else -0.5
			var fa: = a0 + fsign
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, Vector3(target.x + sin(fa) * rh, cur.y, target.z + cos(fa) * rh), target, fov0)
		"follow_push":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, target + fwd * rh * 0.4 + Vector3.UP * (h - target.y) * 0.5, target, fov0)
		"low_push":
			var p0: = Vector3(cur.x, maxf(0.5, target.y * 0.35), cur.z)
			var p1: = target + fwd * rh * 0.4
			p1.y = maxf(0.8, target.y * 0.5)
			_pk(ck, 0.0, p0, target, fov0)
			_pk(ck, D, p1, target, fov0)
		"shoulder_push":
			var sp_end: = target + (fwd + right * 0.3).normalized() * rh * 0.32
			sp_end.y = target.y + 0.2
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, sp_end, target, fov0)
		"pov":
			var eye: = 1.6
			var p0: = cur
			p0.y = eye
			var step: = - fwd * rh * 0.7
			_pk(ck, 0.0, p0, p0 - fwd * 4.0, fov0)
			_pk(ck, D, p0 + step, p0 + step - fwd * 4.0, fov0)
		"handheld":
			var n3: = 8
			for i in range(n3):
				var f: = float(i) / (n3 - 1)
				var pos: = cur.lerp(target + dirc * rh * 0.4 + Vector3.UP * 0.3, f)
				pos += right * 0.09 * sin(f * 13.0) + Vector3.UP * 0.06 * sin(f * 17.0 + 1.0)
				_pk(ck, D * f, pos, target, fov0, 0.02 * sin(f * 11.0))
		"rise_top":
			var rt_alt: = rh * 1.8 + 5.0
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, Vector3(cur.x, target.y + rt_alt, cur.z), target, fov0)
		"top_fall":
			var tf_alt: = rh * 1.8 + 5.0
			_pk(ck, 0.0, Vector3(cur.x, target.y + tf_alt, cur.z), target, fov0)
			_pk(ck, D, target + fwd * rh * 0.4 + Vector3.UP * maxf(rh * 0.4, 1.0), target, fov0)
		"god_view":
			var gp: = Vector3(cur.x, target.y + rh * 2.0 + 6.0, cur.z)
			_pk(ck, 0.0, gp, target, fov0)
			_pk(ck, D, gp + right * rh * 0.3, target, fov0)
		"flyover":
			var alt: = rh * 1.5 + 5.0
			var fo0: = Vector3(cur.x, target.y + alt, cur.z)
			_pk(ck, 0.0, fo0, target, fov0)
			_pk(ck, D, fo0 - fwd * rh * 2.6, target, fov0)
		"low_pass":
			var p2: = target + (right - fwd * 0.35) * rh
			p2.y = 0.6
			var p3: = target + ( - right - fwd * 0.35) * rh
			p3.y = 0.6
			_pk(ck, 0.0, p2, target, fov0)
			_pk(ck, D, p3, target, fov0)
		"dive":
			_pk(ck, 0.0, Vector3(cur.x, target.y + rh * 1.6 + 4.0, cur.z), target, fov0)
			var low_end: = target + fwd * rh * 0.4
			low_end.y = maxf(target.y * 0.5, 0.8)
			_pk(ck, D, low_end, target, fov0)
		"hero_intro":
			var p4: = Vector3(cur.x, maxf(0.35, target.y * 0.25), cur.z)
			var p5: = target + fwd * rh * 0.55
			p5.y = target.y + 0.7
			_pk(ck, 0.0, p4, target + Vector3.UP * 0.5, fov0)
			_pk(ck, D, p5, target, fov0)
		"menace":
			var m1: = target + fwd * rh * 0.32
			m1.y = maxf(0.5, target.y * 0.6)
			_pk(ck, 0.0, cur, target, fov0, 0.0)
			_pk(ck, D, m1, target, fov0 * 0.9, 0.07)
		"epic_open":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + dirc * rh * 1.4 + Vector3.UP * rh * 0.7, target, fov0 * 1.1)
		"intimate":
			var n4: = 4
			for i in range(n4):
				var f: = float(i) / (n4 - 1)
				var a: = a0 + PI * 0.22 * f
				var rr: = rh * lerpf(1.0, 0.45, f)
				var pos: = target + Vector3(sin(a), 0, cos(a)) * rr
				pos.y = lerpf(h, target.y + 0.15, f)
				_pk(ck, D * f, pos, target, lerpf(fov0, 38.0, f))
		"standoff":
			var n5: = 4
			for i in range(n5):
				var f: = float(i) / (n5 - 1)
				var a: = a0 + PI * 0.3 * f
				var rr: = rh * lerpf(1.0, 0.8, f)
				var pos: = target + Vector3(sin(a), 0, cos(a)) * rr
				pos.y = lerpf(h, target.y + 0.3, f)
				_pk(ck, D * f, pos, target, lerpf(fov0, 45.0, f))
		"reveal":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + dirc * rh * 1.3 + Vector3.UP * rh * 0.6, target, fov0)
		"peek":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur + right * rh * 0.45 + dirc * rh * 0.1, target, maxf(fov0 * 0.8, 32.0))
		"dutch":
			_pk(ck, 0.0, cur, target, fov0, 0.0)
			_pk(ck, D, target + dirc * rh * 0.6 + Vector3.UP * 0.2, target, fov0, 0.21)
		"barrel_roll":
			var n6: = 5
			for i in range(n6):
				var f: = float(i) / (n6 - 1)
				var pos: = cur.lerp(target + dirc * rh * 0.6, f * 0.5)
				_pk(ck, D * f, pos, target, fov0, TAU * f)
		"chase":
			var c1: = target + fwd * rh * 0.35 - right * rh * 0.2
			c1.y = maxf(0.8, target.y * 0.7)
			_pk(ck, 0.0, cur, target, fov0 * 1.05)
			_pk(ck, D, c1, target, fov0)
		"fg_sweep":
			_pk(ck, 0.0, cur, target, fov0)
			_pk(ck, D, cur - right * rh * 1.0, target, fov0)
	return ck



func _open_preset_preview(key: String, cn: String) -> void :
	_dialog_key = key
	_dialog_cn = cn
	preview_dialog.title = "预制镜头 · " + cn
	var sheet_path: = "res://previews/%s.png" % key
	if ResourceLoader.exists(sheet_path):
		var sheet: = load(sheet_path) as Texture2D
		_dialog_atlas = AtlasTexture.new()
		_dialog_atlas.atlas = sheet
		_dialog_atlas.region = Rect2(0, 0, 160, 90)
		_dialog_frames = maxi(sheet.get_width() / 160, 1)
		_dialog_rect.texture = _dialog_atlas
	else:
		_dialog_atlas = null
		_dialog_rect.texture = null
	preview_dialog.popup_centered()



func _apply_camera_preset(key: String, cn: String) -> void :
	var obj: = scene_manager.selected
	var target: = _scene_center()
	if obj:
		var aabb: = scene_manager.get_local_aabb(obj)
		target = obj.global_position + Vector3.UP * aabb.size.y * obj.scale.y * 0.5
	var keys: = _generate_preset_keys(key, {
		"target": target, 
		"cur": fly_cam.global_position, 
		"fov0": fly_cam.fov_deg, 
		"D": _duration(), 
	})
	if keys.is_empty():
		return
	var ck: = _cam_kf()
	ck.clear()
	ck.append_array(keys)
	playhead = 0.0
	playing = false
	playing_all = false
	_sync_play_btn()
	_apply_at(0.0)
	_after_keys_changed()
	_status("已套用预制镜头「%s」(替换本段相机帧)· 空格预览" % cn)




func _create_shot() -> void :
	shots.append(_make_shot("段落%d" % (shots.size() + 1)))
	_switch_shot(shots.size() - 1)
	_status("已新建 " + String(_shot().name))


func _duplicate_shot() -> void :
	var src: = _shot()
	shots.append({
		"name": "段落%d" % (shots.size() + 1), 
		"duration": float(src.duration), 
		"handheld": float(src.get("handheld", 0.0)), 
		"cam_kf": (src.cam_kf as Array).duplicate(true), 
		"obj_kf": (src.obj_kf as Dictionary).duplicate(true), 
	})
	_switch_shot(shots.size() - 1)
	_status("已复制为 " + String(_shot().name))


func _delete_shot() -> void :
	if shots.size() <= 1:
		_status("至少保留一个段落")
		return
	var removed: String = _shot().name
	shots.remove_at(cur_shot)
	_switch_shot(mini(cur_shot, shots.size() - 1))
	_status("已删除 " + removed)


func _switch_shot(idx: int) -> void :
	_goto_shot(idx, false)
	if not _shot().has("thumb"):
		_capture_shot_thumb.call_deferred()


func _goto_shot(idx: int, keep_playing: bool) -> void :
	cur_shot = clampi(idx, 0, shots.size() - 1)
	playhead = 0.0
	if not keep_playing:
		playing = false
		playing_all = false
	_sync_play_btn()
	_sync_shot_ui()
	_apply_at(0.0)
	if not keep_playing:
		_regen_wp_thumbs.call_deferred()


func _sync_shot_ui() -> void :
	if not timeline:
		return
	timeline.duration = _duration()
	timeline.playhead = playhead
	duration_spin.set_value_no_signal(_duration())
	if auto_dur_spin:
		auto_dur_spin.set_value_no_signal(_duration())
	if handheld_check:
		var hh: = float(_shot().get("handheld", 0.0))
		handheld_check.set_pressed_no_signal(hh > 0.001)
		if hh > 0.001:
			_handheld_amp = hh
			handheld_slider.set_value_no_signal(hh)
	_update_time_label()
	_refresh_tracks()
	_refresh_clip_strip()
	_sync_auto_count()
	_refresh_wp_strip()



func _refresh_tracks() -> void :
	if not timeline:
		return
	var tracks: = [{"name": "📷 相机", "keys": _cam_kf(), "color": UITheme.KEY_CAM}]
	var okf: = _obj_kf()
	for oname in okf:
		if not (okf[oname] as Array).is_empty():
			tracks.append({"name": String(oname), "keys": okf[oname], 
				"color": UITheme.KEY_OBJ})
	timeline.set_tracks(tracks)

	if bottom_card:
		_sync_bottom_height.call_deferred()


func _sync_bottom_height() -> void :
	if not bottom_card:
		return
	bottom_card.offset_top = - (bottom_card.get_combined_minimum_size().y + 16.0)
	if status_chip and shoot_mode:
		status_chip.offset_top = bottom_card.offset_top - 48.0
		status_chip.offset_bottom = bottom_card.offset_top - 8.0
	_update_frame_safe_rect()




func _update_frame_safe_rect() -> void :
	if not frame_overlay:
		return
	var win: = get_viewport().get_visible_rect().size
	var left: = 0.0
	var lp: Control = shoot_left_panel if shoot_mode else layout_left_panel
	if lp and lp.visible:
		left = lp.global_position.x + lp.size.x
	var top: = 118.0
	var bottom: = win.y
	if bottom_card and bottom_card.visible:
		bottom = win.y + bottom_card.offset_top
	var right: = win.x
	if right_panel and right_panel.visible:
		right = right_panel.global_position.x
	frame_overlay.set_safe_rect(Rect2(
		left, top, maxf(right - left, 80.0), maxf(bottom - top, 80.0)))


func _refresh_clip_strip() -> void :
	if not clip_strip:
		return
	for c in clip_strip.get_children():
		clip_strip.remove_child(c)
		c.queue_free()
	for i in range(shots.size()):
		var s: = shots[i]
		var btn: = Button.new()
		btn.custom_minimum_size = Vector2(172, 62)
		btn.theme_type_variation = "RowSelected" if i == cur_shot else "AssetCard"
		btn.focus_mode = Control.FOCUS_NONE
		btn.text = "%s\n%.1fs · %d帧" % [s.name, float(s.duration), (s.cam_kf as Array).size()]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		if s.has("thumb"):
			btn.icon = s.thumb
			btn.expand_icon = true
		var idx: = i
		btn.pressed.connect( func() -> void : _switch_shot(idx))
		btn.tooltip_text = "点击切换 · 拖动可调整前后顺序"
		btn.set_drag_forwarding(
			_shot_drag_data.bind(idx), 
			_shot_can_drop.bind(idx), 
			_shot_drop.bind(idx))
		clip_strip.add_child(btn)
	var add_btn: = _make_button("＋", _create_shot)
	add_btn.custom_minimum_size = Vector2(44, 62)
	add_btn.tooltip_text = "新建段落"
	clip_strip.add_child(add_btn)
	var dup_btn: = _make_button("⧉", _duplicate_shot)
	dup_btn.custom_minimum_size = Vector2(44, 62)
	dup_btn.tooltip_text = "复制当前段落"
	dup_btn.theme_type_variation = "GhostButton"
	clip_strip.add_child(dup_btn)
	var del_btn: = _make_button("🗑", _delete_shot)
	del_btn.custom_minimum_size = Vector2(44, 62)
	del_btn.tooltip_text = "删除当前段落"
	del_btn.theme_type_variation = "GhostButton"
	clip_strip.add_child(del_btn)



func _shot_drag_data(_at: Vector2, from_idx: int) -> Variant:
	var prev: = Label.new()
	prev.text = "  ↔ " + String(shots[from_idx].name) + "  "
	prev.theme = ui_theme
	clip_strip.set_drag_preview(prev)
	return {"kind": "shot", "from": from_idx}


func _shot_can_drop(_at: Vector2, data: Variant, _to_idx: int) -> bool:
	return typeof(data) == TYPE_DICTIONARY and String((data as Dictionary).get("kind", "")) == "shot"


func _shot_drop(_at: Vector2, data: Variant, to_idx: int) -> void :
	_move_shot(int((data as Dictionary).get("from", -1)), to_idx)



func _move_shot(from: int, to: int) -> void :
	if from < 0 or from >= shots.size() or from == to:
		return
	var cur_ref = shots[cur_shot]
	var moved = shots[from]
	shots.remove_at(from)
	shots.insert(clampi(to, 0, shots.size()), moved)
	cur_shot = shots.find(cur_ref)
	_refresh_clip_strip()
	_status("段落顺序已调整")



func _capture_shot_thumb() -> void :
	if render_mode or _thumb_busy or thumb_vp == null:
		return
	var ck: = _cam_kf()
	if ck.is_empty():
		return
	_thumb_busy = true
	var idx: = cur_shot
	var s: = _sample_keys(ck, 0.0)
	thumb_cam.global_transform = Transform3D(Basis(s.rot as Quaternion), s.pos as Vector3)
	thumb_cam.fov = float(s.get("fov", 60.0))
	thumb_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	if idx < shots.size():
		shots[idx]["thumb"] = ImageTexture.create_from_image(thumb_vp.get_texture().get_image())
	_thumb_busy = false
	_refresh_clip_strip()




func _update_gizmo() -> void :
	if gizmo == null:
		return
	var obj: = scene_manager.selected
	if obj == null or not is_instance_valid(obj):
		gizmo.visible = false
		if scale_handle:
			scale_handle.visible = false
		return
	gizmo.visible = true
	gizmo.global_position = obj.global_position


	var aabb: = scene_manager.get_local_aabb(obj)
	var wsize: = aabb.size * obj.scale


	var foot: = maxf(wsize.x, wsize.z)
	var extent: = maxf(foot, wsize.y * 0.25)
	extent = maxf(extent, 0.45)
	var s: = clampf(extent * 0.6, 0.26, 1.3)
	gizmo.scale = Vector3.ONE * s

	if scale_handle:
		scale_handle.visible = true
		var corner: = aabb.position + aabb.size
		scale_handle.global_position = obj.global_transform * corner
		scale_handle.scale = Vector3.ONE * (s * 0.32)


func _make_scale_handle() -> MeshInstance3D:
	var mi: = MeshInstance3D.new()
	mi.name = "_ScaleHandle"
	var q: = QuadMesh.new()
	q.size = Vector2(0.34, 0.34)
	mi.mesh = q
	var m: = StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = Color(0.96, 0.62, 0.04, 0.72)
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	m.billboard_keep_scale = true
	m.no_depth_test = true
	m.render_priority = 12
	mi.material_override = m
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mi.layers = 2
	mi.visible = false
	return mi


func _unhandled_input(event: InputEvent) -> void :
	if render_mode:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			get_viewport().gui_release_focus()
			if event.double_click:
				_try_rename_at(event.position)
			elif event.ctrl_pressed:
				_ctrl_press(event.position)
			else:
				_try_begin_drag(event.position, event.alt_pressed)
		else:
			_dragging = false
			_axis_drag = ""
			_rot_drag = ""
			_scaling = false
			_undo_pushed_this_drag = false
			if _band_active:
				_finish_band_select(event.position)
	elif event is InputEventMouseMotion:
		if _band_active:
			_update_band(event.position)
		elif _scaling:
			_update_scale(event.position)
		elif not _rot_drag.is_empty():
			_update_ring_rotate(event.position)
		elif scene_manager.selected:
			if not _axis_drag.is_empty():
				_update_axis_drag(event.position)
			elif _dragging:
				_update_drag(event.relative)



func _ctrl_press(mpos: Vector2) -> void :
	if fly_cam.looking:
		return
	var ray: = fly_cam.mouse_ray(mpos)
	var origin: Vector3 = ray[0]
	var dir: Vector3 = ray[1]
	var hit: = scene_manager.pick(origin, dir)
	if hit:
		scene_manager.toggle_select(hit)
		_status("已选中 %d 个物体(Ctrl+G 打组)" % scene_manager.selected_list.size())
	else:
		_band_active = true
		_band_start = mpos
		band_rect.visible = true
		band_rect.position = mpos
		band_rect.size = Vector2.ZERO


func _update_band(mpos: Vector2) -> void :
	var tl: = Vector2(minf(_band_start.x, mpos.x), minf(_band_start.y, mpos.y))
	var br: = Vector2(maxf(_band_start.x, mpos.x), maxf(_band_start.y, mpos.y))
	band_rect.position = tl
	band_rect.size = br - tl


func _finish_band_select(mpos: Vector2) -> void :
	_band_active = false
	band_rect.visible = false
	var rect: = Rect2(band_rect.position, band_rect.size)
	if rect.size.length() < 8.0:
		return
	var picked: Array = []
	for obj in scene_manager.list_objects():
		if not obj.visible:
			continue
		var wp: Vector3 = obj.global_position\
		+ Vector3.UP * scene_manager.get_local_aabb(obj).size.y * obj.scale.y * 0.5
		var sp = fly_cam.world_to_screen(wp)
		if sp == null:
			continue
		if rect.has_point(sp):
			picked.append(obj)
	scene_manager.select_many(picked)
	_status("框选了 %d 个物体(Ctrl+G 打组)" % picked.size())



func _try_rename_at(mpos: Vector2) -> void :
	if fly_cam.looking:
		return
	var ray: = fly_cam.mouse_ray(mpos)
	var origin: Vector3 = ray[0]
	var dir: Vector3 = ray[1]
	var hit: = scene_manager.pick(origin, dir)
	if hit == null:
		return
	scene_manager.select(hit)
	rename_edit.text = String(hit.name)
	rename_dialog.popup_centered(Vector2i(360, 0))
	rename_edit.grab_focus()
	rename_edit.select_all()


func _group_selected() -> void :
	if scene_manager.selected_list.size() >= 2:
		_push_undo()
	var g: = scene_manager.group_selected()
	if g:
		_status("已打组:" + String(g.name) + "(可整体移动/打帧,Ctrl+Shift+G 解组)")
	else:
		_status("先 Ctrl+点选 或 Ctrl+框选 至少 2 个物体再打组")


func _ungroup_selected() -> void :
	var g: = scene_manager.selected
	if g and String(g.get_meta("kind", "")) == "group":
		_push_undo()
		var gname: = String(g.name)
		for s in shots:
			(s.obj_kf as Dictionary).erase(gname)
		scene_manager.ungroup_selected()
		_refresh_tracks()
		_status("已解组 " + gname)
	else:
		_status("先选中一个组再解组")


func _unhandled_key_input(event: InputEvent) -> void :
	if render_mode:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_K:
				if auto_mode and shoot_mode:
					_record_waypoint()
				else:
					_add_camera_keyframe()
			KEY_J:
				if auto_mode and shoot_mode:
					_status("自动版会连物体位置一起记录,直接按 K 即可")
				else:
					_add_object_keyframe()
			KEY_SPACE:
				_toggle_play()
			KEY_DELETE:
				_delete_selected_object()
			KEY_C:
				if event.ctrl_pressed:
					_push_undo()
					scene_manager.duplicate_selected()
			KEY_Z:
				if event.ctrl_pressed:
					_undo()
			KEY_S:
				if event.ctrl_pressed:
					_quick_save()
			KEY_G:
				if event.ctrl_pressed and event.shift_pressed:
					_ungroup_selected()
				elif event.ctrl_pressed:
					_group_selected()
			KEY_BRACKETLEFT:
				_rotate_selected(-15.0)
			KEY_BRACKETRIGHT:
				_rotate_selected(15.0)
			KEY_HOME:
				playhead = 0.0
				playing = false
				_apply_at(0.0)
				if timeline:
					timeline.playhead = 0.0
				_update_time_label()
			KEY_5, KEY_KP_5:
				_set_view("persp")
			KEY_2, KEY_KP_2:
				_set_view("two_point")


func _set_view(preset: String) -> void :
	playing = false
	_sync_play_btn()
	fly_cam.set_view_preset(preset)
	_sync_view_buttons()
	var names: = {"top": "顶视图(正交)", "front": "前视图(正交)", 
		"right": "右视图(正交)", "persp": "透视", 
		"two_point": "二点透视(竖线保持垂直)"}
	_status("视角:" + names.get(preset, preset))


func _sync_view_buttons() -> void :
	if view_persp_btn:
		view_persp_btn.set_pressed_no_signal( not fly_cam.two_point)
		view_two_btn.set_pressed_no_signal(fly_cam.two_point)


func _try_begin_drag(mpos: Vector2, alt: bool) -> void :
	if fly_cam.looking:
		return
	var ray: = fly_cam.mouse_ray(mpos)
	var origin: Vector3 = ray[0]
	var dir: Vector3 = ray[1]

	if scene_manager.selected and scale_handle and scale_handle.visible:
		var hs = fly_cam.world_to_screen(scale_handle.global_position)
		if hs != null and (hs as Vector2).distance_to(mpos) <= 18.0:
			_begin_scale(mpos)
			return
	if scene_manager.selected and gizmo and gizmo.visible:
		var axis: = gizmo.hit_test(origin, dir)
		if not axis.is_empty():
			if alt:
				_push_undo()
				scene_manager.duplicate_selected()
			_axis_drag = axis
			_axis_dir = TranslateGizmo.AXES[axis][0]
			_axis_anchor = scene_manager.selected.global_position
			_obj_start_pos = _axis_anchor
			_axis_t0 = TranslateGizmo.closest_on_axis(
				_axis_anchor, _axis_dir, origin, dir).x
			_capture_drag_starts()
			return
		var ring: = gizmo.hit_test_ring(origin, dir)
		if not ring.is_empty():
			_begin_ring_rotate(ring, origin, dir)
			return
	var hit: = scene_manager.pick(origin, dir)
	if hit == null:
		scene_manager.select(null)
		return
	if alt:

		if not scene_manager.selected_list.has(hit):
			scene_manager.select(hit)
		_push_undo()
		scene_manager.duplicate_selected()
	elif not (scene_manager.selected_list.size() > 1 and scene_manager.selected_list.has(hit)):

		scene_manager.select(hit)
	var lead: = scene_manager.selected
	if lead and is_instance_valid(lead):
		_dragging = true
		_drag_plane_y = lead.global_position.y
		_drag_pos = lead.global_position
		_capture_drag_starts()



func _begin_ring_rotate(ring: String, origin: Vector3, dir: Vector3) -> void :
	var obj: = scene_manager.selected
	if obj == null:
		return
	_rot_drag = ring
	_rot_axis = (TranslateGizmo.RING_NORMAL[ring] as Vector3).normalized()
	_rot_origin = obj.global_position

	var u: = _rot_axis.cross(Vector3.UP)
	if u.length() < 0.01:
		u = _rot_axis.cross(Vector3.RIGHT)
	_rot_u = u.normalized()
	_rot_v = _rot_axis.cross(_rot_u).normalized()
	_rot_start_basis = obj.global_transform.basis
	_rot_start_angle = _ring_angle(origin, dir)



func _ring_angle(origin: Vector3, dir: Vector3) -> float:
	var denom: = _rot_axis.dot(dir)
	if absf(denom) < 1e-06:
		return _rot_start_angle
	var t: = (_rot_origin - origin).dot(_rot_axis) / denom
	var hit: = origin + dir * t
	var rel: = hit - _rot_origin
	return atan2(rel.dot(_rot_v), rel.dot(_rot_u))


func _update_ring_rotate(mpos: Vector2) -> void :
	var obj: = scene_manager.selected
	if obj == null or not is_instance_valid(obj):
		return
	_undo_once()
	var ray: = fly_cam.mouse_ray(mpos)
	var ang: = _ring_angle(ray[0], ray[1])
	var delta: = ang - _rot_start_angle
	if snap_check and snap_check.button_pressed:
		delta = snappedf(delta, deg_to_rad(15.0))
	var new_basis: = Basis(_rot_axis, delta) * _rot_start_basis
	obj.global_transform = Transform3D(new_basis, _rot_origin)
	_refresh_inspector_values()



func _begin_scale(mpos: Vector2) -> void :
	var obj: = scene_manager.selected
	if obj == null:
		return
	_scaling = true
	_scale_start = obj.scale
	var piv = fly_cam.world_to_screen(obj.global_position)
	_scale_pivot_scr = (piv as Vector2) if piv != null else mpos
	var hs = fly_cam.world_to_screen(scale_handle.global_position)
	var d0: = ((hs as Vector2) - _scale_pivot_scr).length() if hs != null else 8.0
	_scale_d0 = maxf(d0, 8.0)
	var aabb: = scene_manager.get_local_aabb(obj)
	_scale_aabb_miny = aabb.position.y
	_scale_bottom = obj.global_position.y + aabb.position.y * obj.scale.y


func _update_scale(mpos: Vector2) -> void :
	var obj: = scene_manager.selected
	if obj == null or not is_instance_valid(obj):
		return
	_undo_once()
	var ratio: = clampf(mpos.distance_to(_scale_pivot_scr) / _scale_d0, 0.05, 20.0)
	var ns: = _scale_start * ratio
	ns.x = maxf(ns.x, 0.02)
	ns.y = maxf(ns.y, 0.02)
	ns.z = maxf(ns.z, 0.02)
	obj.scale = ns

	obj.global_position.y = _scale_bottom - _scale_aabb_miny * obj.scale.y
	scene_manager.refresh_labels()
	_refresh_inspector_values()



func _capture_drag_starts() -> void :
	_drag_starts = {}
	for o in scene_manager.selected_list:
		if is_instance_valid(o):
			_drag_starts[o] = (o as Node3D).global_position
	var pri: = scene_manager.selected
	if pri and is_instance_valid(pri) and not _drag_starts.has(pri):
		_drag_starts[pri] = pri.global_position



func _apply_drag_delta(delta: Vector3) -> void :
	for o in _drag_starts:
		if is_instance_valid(o):
			(o as Node3D).global_position = (_drag_starts[o] as Vector3) + delta


func _update_axis_drag(mpos: Vector2) -> void :
	_undo_once()
	var ray: = fly_cam.mouse_ray(mpos)
	var origin: Vector3 = ray[0]
	var dir: Vector3 = ray[1]
	var t: = TranslateGizmo.closest_on_axis(_axis_anchor, _axis_dir, origin, dir).x
	var target: = _obj_start_pos + _axis_dir * ((t - _axis_t0) * drag_sensitivity)
	if snap_check and snap_check.button_pressed:
		if _axis_drag == "x":
			target.x = snappedf(target.x, 0.5)
		elif _axis_drag == "y":
			target.y = snappedf(target.y, 0.25)
		else:
			target.z = snappedf(target.z, 0.5)
	var delta: = target - _obj_start_pos
	_apply_drag_delta(delta)
	_refresh_inspector_values()




func _update_drag(rel: Vector2) -> void :
	var obj: = scene_manager.selected
	if obj == null or not is_instance_valid(obj):
		return
	_undo_once()
	var cam: = fly_cam
	var vp_h: float = maxf(get_viewport().get_visible_rect().size.y, 1.0)
	var world_per_px: float
	if cam.projection == Camera3D.PROJECTION_ORTHOGONAL:
		world_per_px = cam.size / vp_h
	else:
		var d: = cam.global_position.distance_to(obj.global_position)
		world_per_px = 2.0 * d * tan(deg_to_rad(cam.fov_deg) * 0.5) / vp_h

	var b: = cam.global_transform.basis
	var right_g: = Vector3(b.x.x, 0.0, b.x.z)
	right_g = right_g.normalized() if right_g.length() > 0.0001 else Vector3.RIGHT
	var fwd: = - b.z
	var fwd_g: = Vector3(fwd.x, 0.0, fwd.z)
	if fwd_g.length() < 0.15:
		fwd_g = Vector3(b.y.x, 0.0, b.y.z)
	fwd_g = fwd_g.normalized() if fwd_g.length() > 0.0001 else Vector3.FORWARD
	var step: = drag_sensitivity * world_per_px
	_drag_pos += right_g * (rel.x * step) + fwd_g * ( - rel.y * step)
	var target: = _drag_pos
	if snap_check and snap_check.button_pressed:
		target.x = snappedf(target.x, 0.5)
		target.z = snappedf(target.z, 0.5)


	if _drag_starts.size() > 1:

		var pstart: Vector3 = _drag_starts.get(obj, obj.global_position)
		var dxz: = Vector3(target.x - pstart.x, 0.0, target.z - pstart.z)
		for o in _drag_starts:
			if is_instance_valid(o):
				var st: Vector3 = _drag_starts[o]
				(o as Node3D).global_position = Vector3(st.x + dxz.x, st.y, st.z + dxz.z)
	else:

		var support: = _support_height_at(target.x, target.z, obj)
		var wa: = _world_aabb_of(obj)
		var bottom_off: = wa.position.y - obj.global_position.y
		obj.global_position = Vector3(target.x, support - bottom_off, target.z)
	_refresh_inspector_values()



func _world_aabb_of(o: Node3D) -> AABB:
	var la: = scene_manager.get_local_aabb(o)
	var xf: = o.global_transform
	var box: = AABB(xf * la.position, Vector3.ZERO)
	for i in range(1, 8):
		var corner: = la.position + Vector3(
			la.size.x if (i & 1) else 0.0, 
			la.size.y if (i & 2) else 0.0, 
			la.size.z if (i & 4) else 0.0)
		box = box.expand(xf * corner)
	return box



func _support_height_at(x: float, z: float, exclude: Node3D) -> float:
	var h: = 0.0
	for o in scene_manager.list_objects():
		if o == exclude or not is_instance_valid(o):
			continue
		var wa: = _world_aabb_of(o)
		if x >= wa.position.x - 0.02 and x <= wa.position.x + wa.size.x + 0.02\
		and z >= wa.position.z - 0.02 and z <= wa.position.z + wa.size.z + 0.02:
			h = maxf(h, wa.position.y + wa.size.y)
	return h



func _undo_once() -> void :
	if not _undo_pushed_this_drag:
		_push_undo()
		_undo_pushed_this_drag = true



func _push_undo() -> void :
	_undo_stack.append(scene_manager.serialize())
	if _undo_stack.size() > UNDO_MAX:
		_undo_stack.pop_front()



func _undo() -> void :
	if _undo_stack.is_empty():
		_status("没有可撤销的操作了")
		return
	var snap: Array = _undo_stack.pop_back()
	scene_manager.load_objects(snap, model_lookup)
	scene_manager.select(null)
	_refresh_object_list()
	_refresh_tracks()
	_status("已撤销(还可撤 %d 步)" % _undo_stack.size())


func _rotate_selected(deg: float) -> void :
	if scene_manager.selected:
		_push_undo()
		scene_manager.selected.rotate_y(deg_to_rad(deg))
		_refresh_inspector_values()


func _delete_selected_object() -> void :
	if scene_manager.selected_list.is_empty():
		return
	_push_undo()
	for o in scene_manager.selected_list:
		if is_instance_valid(o):
			var oname: = String(o.name)
			for s in shots:
				(s.obj_kf as Dictionary).erase(oname)
	scene_manager.delete_selected()
	_refresh_tracks()


func _rename_selected_object(new_name: String) -> void :
	var obj: = scene_manager.selected
	if obj == null or new_name.is_empty():
		return
	_push_undo()
	var old: = String(obj.name)
	obj.name = new_name
	var actual: = String(obj.name)
	for s in shots:
		var tracks: Dictionary = s.obj_kf
		if tracks.has(old):
			tracks[actual] = tracks[old]
			tracks.erase(old)
	_status("已重命名为 " + actual)
	scene_manager.refresh_labels()
	scene_manager.objects_changed.emit()
	_refresh_tracks()




func _serialize_project() -> Dictionary:
	var shots_out: = []
	for s in shots:
		var cam_out: = []
		for k in s.cam_kf:
			cam_out.append({
				"t": float(k.t), 
				"pos": [k.pos.x, k.pos.y, k.pos.z], 
				"rot": [k.rot.x, k.rot.y, k.rot.z, k.rot.w], 
				"fov": float(k.fov), 
				"shift": float(k.get("shift", 0.0)), 
			})
		var obj_out: = {}
		for oname in s.obj_kf:
			var track_out: = []
			for k in s.obj_kf[oname]:
				var ko: = {
					"t": float(k.t), 
					"pos": [k.pos.x, k.pos.y, k.pos.z], 
					"rot": [k.rot.x, k.rot.y, k.rot.z, k.rot.w], 
				}
				if String((k as Dictionary).get("pose", "")) != "":
					ko["pose"] = String(k.pose)
				track_out.append(ko)
			obj_out[oname] = track_out
		shots_out.append({
			"name": s.name, 
			"duration": float(s.duration), 
			"handheld": float(s.get("handheld", 0.0)), 
			"cam_kf": cam_out, 
			"obj_kf": obj_out, 
			"wp": _serialize_wp(s.get("wp", [])), 
		})
	return {
		"version": 2, 
		"fps": shot_fps, 
		"objects": scene_manager.serialize(), 
		"shots": shots_out, 
		"env": {"preset": env_preset, "azimuth": sun_azimuth}, 
		"labels_burn": labels_burn, 
	}



func _serialize_wp(wp_arr: Array) -> Array:
	var out: = []
	for wp in wp_arr:
		var objs_out: = {}
		for oname in (wp.get("objs", {}) as Dictionary):
			var st: Dictionary = wp.objs[oname]
			var so: = {
				"pos": [st.pos.x, st.pos.y, st.pos.z], 
				"rot": [st.rot.x, st.rot.y, st.rot.z, st.rot.w], 
			}
			if String(st.get("pose", "")) != "":
				so["pose"] = String(st.pose)
			objs_out[oname] = so
		var cp: Vector3 = wp.get("cam_pos", Vector3.ZERO)
		out.append({
			"t": float(wp.t), 
			"cam_pos": [cp.x, cp.y, cp.z], 
			"objs": objs_out, 
		})
	return out


func _parse_wp(arr: Array) -> Array:
	var out: = []
	for w in arr:
		var objs: = {}
		for oname in (w.get("objs", {}) as Dictionary):
			var so: Dictionary = w.objs[oname]
			var st: = {
				"pos": Vector3(float(so.pos[0]), float(so.pos[1]), float(so.pos[2])), 
				"rot": Quaternion(float(so.rot[0]), float(so.rot[1]), 
					float(so.rot[2]), float(so.rot[3])), 
			}
			if String(so.get("pose", "")) != "":
				st["pose"] = String(so.pose)
			objs[oname] = st
		var cp: Array = w.get("cam_pos", [0, 0, 0])
		out.append({
			"t": float(w.t), 
			"cam_pos": Vector3(float(cp[0]), float(cp[1]), float(cp[2])), 
			"objs": objs, 
		})
	return out


func _parse_keys(arr: Array, with_fov: bool) -> Array:
	var out: = []
	for k in arr:
		var key: = {
			"t": float(k.t), 
			"pos": Vector3(float(k.pos[0]), float(k.pos[1]), float(k.pos[2])), 
			"rot": Quaternion(float(k.rot[0]), float(k.rot[1]), 
				float(k.rot[2]), float(k.rot[3])), 
		}
		if with_fov:
			key["fov"] = float(k.get("fov", 60.0))
			key["shift"] = float(k.get("shift", 0.0))
		if String(k.get("pose", "")) != "":
			key["pose"] = String(k.pose)
		out.append(key)
	out.sort_custom( func(x, y): return float(x.t) < float(y.t))
	return out


func _load_project_data(data: Dictionary) -> bool:
	if data.is_empty():
		return false
	scene_manager.load_objects(data.get("objects", []), model_lookup)
	shot_fps = int(data.get("fps", 60))
	shots.clear()
	if data.has("shots"):
		for s in data.shots:
			shots.append({
				"name": s.get("name", "段落"), 
				"duration": float(s.get("duration", 8.0)), 
				"handheld": float(s.get("handheld", 0.0)), 
				"cam_kf": _parse_keys(s.get("cam_kf", []), true), 
				"obj_kf": _parse_obj_tracks(s.get("obj_kf", {})), 
				"wp": _parse_wp(s.get("wp", [])), 
			})
	elif data.has("shot"):
		var old: Dictionary = data.shot
		shots.append({
			"name": "段落1", 
			"duration": float(old.get("duration", 8.0)), 
			"cam_kf": _parse_keys(old.get("kf", []), true), 
			"obj_kf": {}, 
		})
	if shots.is_empty():
		shots.append(_make_shot("段落1"))
	cur_shot = 0
	playhead = 0.0
	var env_data: Dictionary = data.get("env", {})
	env_preset = String(env_data.get("preset", "day"))
	if not ENV_PRESETS.has(env_preset):
		env_preset = "day"
	sun_azimuth = float(env_data.get("azimuth", 32.0))
	labels_burn = bool(data.get("labels_burn", false))
	_apply_environment()
	if _azimuth_slider:
		_sync_env_chips()
	if burn_check:
		burn_check.set_pressed_no_signal(labels_burn)
	if label_check:
		scene_manager.set_labels_visible(label_check.button_pressed)
	_sync_output_ui()
	return true



func _sync_output_ui() -> void :
	if fps_opt:
		fps_opt.select(FPS_OPTIONS.find(shot_fps) if FPS_OPTIONS.has(shot_fps) else 2)


func _parse_obj_tracks(data: Dictionary) -> Dictionary:
	var out: = {}
	for oname in data:
		out[oname] = _parse_keys(data[oname], false)
	return out


func _save_project_to(path: String, extra: Dictionary = {}) -> void :
	var f: = FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		_status("保存失败:" + path)
		return
	var data: = extra.duplicate()
	if data.is_empty():
		data = _serialize_project()
	f.store_string(JSON.stringify(data, "  "))
	f.flush()


func _load_project_from(path: String) -> bool:
	var txt: = FileAccess.get_file_as_string(path)
	if txt.is_empty():
		return false
	var data = JSON.parse_string(txt)
	if typeof(data) != TYPE_DICTIONARY:
		return false
	if not _load_project_data(data):
		return false
	if timeline:
		_sync_shot_ui()
	_regen_wp_thumbs.call_deferred()
	return true


func _set_project_path(path: String) -> void :
	project_path = path
	if project_label:
		project_label.text = path.get_file().get_basename() if not path.is_empty()\
		else "未命名工程"




func _start_export(mp4_path: String) -> void :
	if not mp4_path.ends_with(".mp4"):
		mp4_path += ".mp4"
	playing = false
	_sync_play_btn()
	_save_project_to(JOB_PATH, {"project": _serialize_project(), "shot": cur_shot})
	export_manager.fps = shot_fps
	_setup_export_crop()
	if export_btn:
		export_btn.disabled = true
	export_manager.start_export(mp4_path)




func _compute_frame_crop() -> Dictionary:
	_update_frame_safe_rect()
	var win: = get_viewport().get_visible_rect().size
	var f: = frame_overlay.get_frame_rect() if frame_overlay else Rect2(Vector2.ZERO, win)
	if f.size.y < 1.0:
		f = Rect2(Vector2.ZERO, win)



	var scale: = 1.0
	var scr: = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	if scr.x > 100 and scr.y > 100:
		scale = minf(scale, float(scr.x) / maxf(win.x, 1.0))
		scale = minf(scale, float(scr.y) / maxf(win.y, 1.0))


	scale = minf(scale, 1920.0 / maxf(win.x, 1.0))
	scale = minf(scale, 1080.0 / maxf(win.y, 1.0))

	var rw: = maxi(2, int(round(win.x * scale * 0.5)) * 2)
	var rh: = maxi(2, int(round(win.y * scale * 0.5)) * 2)
	var cw: = clampi(int(round(f.size.x * scale * 0.5)) * 2, 2, rw)
	var ch: = clampi(int(round(f.size.y * scale * 0.5)) * 2, 2, rh)
	var cx: = clampi(int(round(f.position.x * scale)), 0, rw - cw)
	var cy: = clampi(int(round(f.position.y * scale)), 0, rh - ch)
	return {"rw": rw, "rh": rh, "crop": Rect2i(cx, cy, cw, ch)}


func _setup_export_crop() -> void :
	var c: = _compute_frame_crop()
	export_manager.render_w = int(c.rw)
	export_manager.render_h = int(c.rh)
	export_manager.crop = c.crop as Rect2i



static func _pad_to_16_9(img: Image) -> Image:
	var w: = img.get_width()
	var h: = img.get_height()
	if w < 1 or h < 1:
		return img
	var tw: = w
	var th: = h
	if float(w) / float(h) > 16.0 / 9.0:
		th = int(round(float(w) * 9.0 / 16.0))
	else:
		tw = int(round(float(h) * 16.0 / 9.0))
	if tw == w and th == h:
		return img
	var canvas: = Image.create(tw, th, false, img.get_format())
	canvas.fill(Color.BLACK)
	canvas.blit_rect(img, Rect2i(0, 0, w, h), Vector2i((tw - w) / 2, (th - h) / 2))
	return canvas



func _export_still(path: String) -> void :
	if not path.ends_with(".png"):
		path += ".png"

	var c: = _compute_frame_crop()
	thumb_vp.size = Vector2i(int(c.rw), int(c.rh))
	thumb_cam.global_transform = fly_cam.global_transform
	if fly_cam.projection == Camera3D.PROJECTION_ORTHOGONAL:
		thumb_cam.set_orthogonal(fly_cam.size, FlyCamera.NEAR, FlyCamera.FAR)
	elif fly_cam.two_point:
		var near_h: = 2.0 * FlyCamera.NEAR * tan(deg_to_rad(fly_cam.fov_deg) * 0.5)
		thumb_cam.set_frustum(near_h, 
			Vector2(0.0, FlyCamera.NEAR * tan(fly_cam.look_angle)), 
			FlyCamera.NEAR, FlyCamera.FAR)
	else:
		thumb_cam.set_perspective(fly_cam.fov_deg, FlyCamera.NEAR, FlyCamera.FAR)
	thumb_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var img: = thumb_vp.get_texture().get_image()
	img = img.get_region(c.crop as Rect2i)
	img = _pad_to_16_9(img)
	var err: = img.save_png(path)
	thumb_vp.size = Vector2i(192, 108)
	if err == OK:
		_status("画面已导出:" + path)
		OS.shell_show_in_file_manager(path)
	else:
		_status("画面导出失败")


func _on_export_finished(ok: bool, result: String) -> void :
	if export_btn:
		export_btn.disabled = false
	if ok:
		_status("导出完成:" + result)
		OS.shell_show_in_file_manager(result)
	else:
		_status("导出失败:" + result)




func _build_ui() -> void :
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	ui_theme = UITheme.build()

	var root: = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = ui_theme
	ui_layer.add_child(root)

	_build_motion_blur()
	_build_frame_overlay(root)
	_build_top_bar(root)
	_build_layout_left(root)
	_build_shoot_left(root)
	_build_view_card(root)
	_build_right_panel(root)
	_build_bottom_card(root)
	_build_status(root)
	_build_dialogs(root)

	scene_manager.selection_changed.connect( func(_obj) -> void :
		_refresh_inspector()
		_refresh_tracks()
		_refresh_object_list()
		_update_left_panels())
	scene_manager.objects_changed.connect(_refresh_object_list)
	get_viewport().size_changed.connect(_update_frame_safe_rect)
	_refresh_inspector()
	_refresh_object_list()
	_sync_shot_ui()




func _build_motion_blur() -> void :
	blur_layer = CanvasLayer.new()
	blur_layer.layer = 0
	add_child(blur_layer)
	var rect: = ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh: = Shader.new()
	sh.code = MOTION_BLUR_SHADER
	blur_mat = ShaderMaterial.new()
	blur_mat.shader = sh
	rect.material = blur_mat
	blur_layer.add_child(rect)
	blur_layer.visible = false



func _update_motion_blur(delta: float) -> void :
	if blur_layer == null:
		return
	if not motion_blur_on:
		if blur_layer.visible:
			blur_layer.visible = false
		return
	if _blur_test:
		blur_layer.visible = true
		blur_mat.set_shader_parameter("blur_amt", 0.045)
		return
	var pos: = fly_cam.global_position
	var eul: = fly_cam.global_transform.basis.get_euler()
	var move_speed: = pos.distance_to(_cam_prev_pos) / maxf(delta, 0.0001)
	var turn: = (eul - _cam_prev_euler).length() / maxf(delta, 0.0001)
	_cam_prev_pos = pos
	_cam_prev_euler = eul
	var amt: = clampf(move_speed * 0.0016 + turn * 0.02, 0.0, 0.05)
	blur_layer.visible = amt > 0.003
	if blur_layer.visible:
		blur_mat.set_shader_parameter("blur_amt", amt)


func _build_frame_overlay(root: Control) -> void :
	frame_overlay = FrameOverlay.new()
	frame_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	frame_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame_overlay.visible = false
	root.add_child(frame_overlay)


func _build_top_bar(root: Control) -> void :
	var bar: = PanelContainer.new()
	bar.theme_type_variation = "TopBar"
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_bottom = 52
	root.add_child(bar)
	var box: = HBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	bar.add_child(box)

	var logo: = Label.new()
	logo.text = "  ◼ 白模导演  "
	logo.theme_type_variation = "TitleLabel"
	box.add_child(logo)

	var file_menu: = MenuButton.new()
	file_menu.text = "文件"
	file_menu.focus_mode = Control.FOCUS_NONE
	_file_menu_pop = file_menu.get_popup()
	_file_menu_pop.theme = ui_theme
	_file_menu_pop.id_pressed.connect(_on_file_menu)
	_rebuild_file_menu()
	box.add_child(file_menu)

	var view_btn: = MenuButton.new()
	view_btn.text = "视图"
	view_btn.focus_mode = Control.FOCUS_NONE
	view_menu = view_btn.get_popup()
	view_menu.theme = ui_theme
	view_menu.add_item("透视  (5)", 10)
	view_menu.add_item("二点透视  (2)", 14)
	view_menu.add_separator("界面缩放")
	for it in SCALE_ITEMS:
		view_menu.add_radio_check_item(it[0], it[2])
	_sync_scale_checks()
	view_menu.id_pressed.connect(_on_view_menu)
	box.add_child(view_btn)

	var help_btn: = MenuButton.new()
	help_btn.text = "帮助"
	help_btn.focus_mode = Control.FOCUS_NONE
	var hpop: = help_btn.get_popup()
	hpop.theme = ui_theme
	hpop.add_item("操作说明", 20)
	hpop.add_item("关于(v" + APP_VERSION + ")", 22)
	hpop.id_pressed.connect(_on_help_menu)
	box.add_child(help_btn)


	var mode_pad: = Control.new()
	mode_pad.custom_minimum_size = Vector2(20, 0)
	box.add_child(mode_pad)
	var mode_seg: = PanelContainer.new()
	mode_seg.theme_type_variation = "SegGroup"
	box.add_child(mode_seg)
	var mode_box: = HBoxContainer.new()
	mode_seg.add_child(mode_box)
	var mode_grp: = ButtonGroup.new()
	mode_card_layout = Button.new()
	mode_card_layout.text = "🧊 布景"
	mode_card_layout.theme_type_variation = "SegButton"
	mode_card_layout.toggle_mode = true
	mode_card_layout.button_pressed = true
	mode_card_layout.button_group = mode_grp
	mode_card_layout.focus_mode = Control.FOCUS_NONE
	mode_card_layout.pressed.connect( func() -> void : _set_mode(false))
	mode_box.add_child(mode_card_layout)
	mode_card_shoot = Button.new()
	mode_card_shoot.text = "🎥 拍摄"
	mode_card_shoot.theme_type_variation = "SegButton"
	mode_card_shoot.toggle_mode = true
	mode_card_shoot.button_group = mode_grp
	mode_card_shoot.focus_mode = Control.FOCUS_NONE
	mode_card_shoot.pressed.connect( func() -> void : _set_mode(true))
	mode_box.add_child(mode_card_shoot)

	var sp1: = Control.new()
	sp1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(sp1)
	project_label = Label.new()
	project_label.text = "未命名工程"
	project_label.theme_type_variation = "DimLabel"
	box.add_child(project_label)
	var sp2: = Control.new()
	sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(sp2)

	box.add_child(_make_button("保存", _quick_save))
	box.add_child(_make_button("导出画面", func() -> void :
		_still_dialog.current_file = "画面_%s.png" % String(_shot().name)
		_still_dialog.popup_centered(Vector2i(800, 500))))
	export_btn = _make_button("导出 MP4", func() -> void :
		if _cam_kf().size() < 1:
			_status("当前段落还没有相机关键帧(按 K 或选预制镜头)")
			return
		_export_dialog.current_file = String(_shot().name) + ".mp4"
		_export_dialog.popup_centered(Vector2i(800, 500)))
	export_btn.theme_type_variation = "PrimaryButton"
	box.add_child(export_btn)
	var pad: = Control.new()
	pad.custom_minimum_size = Vector2(8, 0)
	box.add_child(pad)


func _rebuild_file_menu() -> void :
	if not _file_menu_pop:
		return
	_file_menu_pop.clear()
	_file_menu_pop.add_item("新建工程…", 0)
	_file_menu_pop.add_item("打开工程…", 1)
	_file_menu_pop.add_item("保存  (Ctrl+S)", 2)
	_file_menu_pop.add_item("另存为…", 4)
	_file_menu_pop.add_separator()
	_file_menu_pop.add_item("导出本段视频…", 3)
	_file_menu_pop.add_item("导出当前画面…", 5)
	if not recent_files.is_empty():
		_file_menu_pop.add_separator("最近打开")
		for i in range(recent_files.size()):
			var p: = String(recent_files[i])
			_file_menu_pop.add_item(p.get_file(), 100 + i)
			_file_menu_pop.set_item_tooltip(_file_menu_pop.item_count - 1, p)



func _new_project() -> void :
	scene_manager.clear_objects()
	shots = [_make_shot("段落1")]
	cur_shot = 0
	playhead = 0.0
	playing = false
	env_preset = "day"
	sun_azimuth = 32.0
	labels_burn = false
	shot_fps = 60
	_undo_stack.clear()
	_set_project_path("")
	_apply_environment()
	_sync_env_chips()
	if burn_check:
		burn_check.set_pressed_no_signal(false)
	_sync_output_ui()
	_sync_shot_ui()
	_sync_play_btn()
	_refresh_object_list()
	_set_mode(false)
	_status("已新建空白工程")


func _on_help_menu(id: int) -> void :
	match id:
		20:
			help_dialog.popup_centered()
		22:
			_status("CineForge 白模预演 v%s" % APP_VERSION)


func _on_file_menu(id: int) -> void :
	if id >= 100:
		var p: = String(recent_files[id - 100])
		if _load_project_from(p):
			_set_project_path(p)
			_add_recent(p)
			_status("已打开:" + p)
			_apply_at(0.0)
		else:
			_status("打开失败(文件不存在或已损坏):" + p)
		return
	match id:
		0:
			new_dialog.popup_centered()
		1:
			_open_dialog.popup_centered(Vector2i(800, 500))
		2:
			_quick_save()
		4:
			_save_dialog.popup_centered(Vector2i(800, 500))
		3:
			if _cam_kf().size() >= 1:
				_export_dialog.current_file = String(_shot().name) + ".mp4"
				_export_dialog.popup_centered(Vector2i(800, 500))
			else:
				_status("当前段落还没有相机关键帧")
		5:
			_still_dialog.popup_centered(Vector2i(800, 500))



func _quick_save() -> void :
	if project_path.is_empty():
		_save_dialog.popup_centered(Vector2i(800, 500))
		return
	_save_project_to(project_path)
	_status("已保存:" + project_path)


func _on_view_menu(id: int) -> void :
	match id:
		10: _set_view("persp")
		14: _set_view("two_point")
		_:
			for it in SCALE_ITEMS:
				if it[2] == id:
					ui_scale_setting = float(it[1])
					_apply_ui_scale()
					_save_settings()
					_sync_scale_checks()


func _sync_scale_checks() -> void :
	for it in SCALE_ITEMS:
		var idx: = view_menu.get_item_index(it[2])
		view_menu.set_item_checked(idx, absf(float(it[1]) - ui_scale_setting) < 0.01)


func _build_layout_left(root: Control) -> void :
	layout_left_panel = PanelContainer.new()
	layout_left_panel.anchor_top = 0.0
	layout_left_panel.anchor_bottom = 1.0
	layout_left_panel.offset_left = 0
	layout_left_panel.offset_right = 352
	layout_left_panel.offset_top = 56
	layout_left_panel.offset_bottom = 0
	root.add_child(layout_left_panel)

	var box: = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	layout_left_panel.add_child(box)

	var env_title: = Label.new()
	env_title.text = "环境 · 时段"
	env_title.theme_type_variation = "DimLabel"
	box.add_child(env_title)
	var env_row: = HBoxContainer.new()
	env_row.add_theme_constant_override("separation", 4)
	box.add_child(env_row)
	for key in ENV_ORDER:
		var chip: = Button.new()
		chip.text = String(ENV_PRESETS[key].cn)
		chip.toggle_mode = true
		chip.button_pressed = key == env_preset
		chip.theme_type_variation = "ToggleChip"
		chip.focus_mode = Control.FOCUS_NONE
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var k: String = key
		chip.pressed.connect( func() -> void : _set_env_preset(k))
		env_row.add_child(chip)
		_env_chips[key] = chip
	var azi_row: = HBoxContainer.new()
	box.add_child(azi_row)
	var azi_label: = Label.new()
	azi_label.text = "太阳方位"
	azi_label.theme_type_variation = "DimLabel"
	azi_row.add_child(azi_label)
	_azimuth_slider = HSlider.new()
	_azimuth_slider.min_value = 0
	_azimuth_slider.max_value = 360
	_azimuth_slider.value = sun_azimuth
	_azimuth_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_azimuth_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_azimuth_slider.focus_mode = Control.FOCUS_NONE
	_azimuth_slider.value_changed.connect( func(v: float) -> void :
		sun_azimuth = v
		_apply_environment())
	azi_row.add_child(_azimuth_slider)

	box.add_child(HSeparator.new())
	var list_title: = Label.new()
	list_title.text = "物体列表"
	list_title.theme_type_variation = "DimLabel"
	box.add_child(list_title)
	var scroll: = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	obj_list_box = VBoxContainer.new()
	obj_list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	obj_list_box.add_theme_constant_override("separation", 2)
	scroll.add_child(obj_list_box)

	box.add_child(HSeparator.new())
	_build_props(box)


func _build_shoot_left(root: Control) -> void :
	shoot_left_panel = PanelContainer.new()
	shoot_left_panel.anchor_top = 0.0
	shoot_left_panel.anchor_bottom = 1.0
	shoot_left_panel.offset_left = 0
	shoot_left_panel.offset_right = 352
	shoot_left_panel.offset_top = 56
	shoot_left_panel.offset_bottom = 0
	root.add_child(shoot_left_panel)

	var box: = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	shoot_left_panel.add_child(box)

	var title: = Label.new()
	title.text = "预制镜头(点击套用到当前段落)"
	title.theme_type_variation = "DimLabel"
	box.add_child(title)

	var scroll: = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var plist: = VBoxContainer.new()
	plist.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	plist.add_theme_constant_override("separation", 6)
	scroll.add_child(plist)

	_preset_cards.clear()
	var seen_cats: Array = []
	var cat_grids: Dictionary = {}
	for p in CAM_PRESETS:
		var cat: = String(p.get("cat", "其他"))
		if not seen_cats.has(cat):
			seen_cats.append(cat)
			var cat_label: = Label.new()
			cat_label.text = cat
			cat_label.theme_type_variation = "DimLabel"
			plist.add_child(cat_label)
			var g: = GridContainer.new()
			g.columns = 2
			g.add_theme_constant_override("h_separation", 6)
			g.add_theme_constant_override("v_separation", 6)
			g.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			plist.add_child(g)
			cat_grids[cat] = g
		var pk: String = p.key
		var pcn: String = p.cn
		var card: = Button.new()
		card.theme_type_variation = "AssetCard"
		card.focus_mode = Control.FOCUS_NONE
		card.custom_minimum_size = Vector2(136, 112)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.text = pcn
		card.clip_text = true
		card.alignment = HORIZONTAL_ALIGNMENT_CENTER
		var sheet_path: = "res://previews/%s.png" % pk
		if ResourceLoader.exists(sheet_path):
			var sheet: = load(sheet_path) as Texture2D
			var at: = AtlasTexture.new()
			at.atlas = sheet
			at.region = Rect2(0, 0, 160, 90)
			card.icon = at
			card.expand_icon = true
			card.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			card.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
			var entry: = {"atlas": at, "frames": maxi(sheet.get_width() / 160, 1), 
				"hovered": false}
			card.mouse_entered.connect( func() -> void : entry.hovered = true)
			card.mouse_exited.connect( func() -> void :
				entry.hovered = false
				at.region = Rect2(0, 0, 160, 90))
			_preset_cards.append(entry)
		card.pressed.connect( func() -> void : _open_preset_preview(pk, pcn))
		(cat_grids[cat] as GridContainer).add_child(card)

	var hint: = Label.new()
	hint.text = "以选中物体为主体(没选则用场景中心)\n半径取当前相机距离,先飞到合适远近再套用"

	hint.theme_type_variation = "DimLabel"
	box.add_child(hint)


func _build_props(box: VBoxContainer) -> void :
	props_box = VBoxContainer.new()
	props_box.add_theme_constant_override("separation", 6)
	box.add_child(props_box)

	var props_title: = Label.new()
	props_title.text = "属性"
	props_title.theme_type_variation = "DimLabel"
	props_box.add_child(props_title)

	name_edit = LineEdit.new()
	name_edit.placeholder_text = "名称"
	name_edit.text_submitted.connect( func(text: String) -> void :
		_rename_selected_object(text))
	props_box.add_child(name_edit)

	var tab_seg: = PanelContainer.new()
	tab_seg.theme_type_variation = "SegGroup"
	props_box.add_child(tab_seg)
	var tab_box: = HBoxContainer.new()
	tab_box.add_theme_constant_override("separation", 2)
	tab_seg.add_child(tab_box)
	var tab_group: = ButtonGroup.new()
	var tab_names: = ["变换", "材质", "灯光"]
	for i in range(tab_names.size()):
		var tb: = Button.new()
		tb.text = tab_names[i]
		tb.toggle_mode = true
		tb.button_group = tab_group
		tb.button_pressed = i == 0
		tb.theme_type_variation = "SegButton"
		tb.focus_mode = Control.FOCUS_NONE
		tb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var idx: = i
		tb.pressed.connect( func() -> void : _show_props_tab(idx))
		tab_box.add_child(tb)

	tab_transform_box = VBoxContainer.new()
	tab_transform_box.add_theme_constant_override("separation", 6)
	props_box.add_child(tab_transform_box)
	var grid_c: = GridContainer.new()
	grid_c.columns = 4
	tab_transform_box.add_child(grid_c)
	_add_vec_row(grid_c, "位置", "p", -1000.0, 1000.0, 0.01)
	_add_vec_row(grid_c, "旋转", "r", -360.0, 360.0, 0.1)
	_add_vec_row(grid_c, "缩放", "s", 0.01, 100.0, 0.01)


	var rot_row: = HBoxContainer.new()
	rot_row.add_theme_constant_override("separation", 4)
	tab_transform_box.add_child(rot_row)
	var rot_label: = Label.new()
	rot_label.text = "转向"
	rot_label.custom_minimum_size = Vector2(34, 0)
	rot_row.add_child(rot_label)
	for spec in [["↺90", -90.0], ["↺15", -15.0], ["↻15", 15.0], ["↻90", 90.0]]:
		var deg: = float(spec[1])
		var rb: = _make_button(String(spec[0]), func() -> void : _rotate_selected(deg))
		rb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rb.tooltip_text = "绕竖直轴旋转 %d°(也可用 [ ] 键)" % int(deg)
		rot_row.add_child(rb)
	var rot_reset_btn: = _make_button("归零", func() -> void :
		if scene_manager.selected:
			_push_undo()
			scene_manager.selected.rotation = Vector3.ZERO
			_refresh_inspector_values())
	rot_reset_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rot_reset_btn.tooltip_text = "旋转全部归零(含俯仰/翻滚)"
	rot_row.add_child(rot_reset_btn)

	tab_material_box = VBoxContainer.new()
	tab_material_box.add_theme_constant_override("separation", 6)
	tab_material_box.visible = false
	props_box.add_child(tab_material_box)
	var color_row: = HBoxContainer.new()
	tab_material_box.add_child(color_row)
	var color_label: = Label.new()
	color_label.text = "颜色"
	color_row.add_child(color_label)
	color_btn = ColorPickerButton.new()
	color_btn.custom_minimum_size = Vector2(160, 30)
	color_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	color_btn.focus_mode = Control.FOCUS_NONE
	color_btn.tooltip_text = "点击打开调色盘,任意自定义颜色"
	color_btn.get_popup().theme = ui_theme
	color_btn.color_changed.connect( func(c: Color) -> void :
		_push_undo()
		scene_manager.set_selected_color(c))
	color_row.add_child(color_btn)
	var custom_hint: = Label.new()
	custom_hint.text = "点色块可自定义任意颜色"
	custom_hint.theme_type_variation = "DimLabel"
	tab_material_box.add_child(custom_hint)
	var preset_row: = GridContainer.new()
	preset_row.columns = 6
	preset_row.add_theme_constant_override("h_separation", 4)
	preset_row.add_theme_constant_override("v_separation", 4)
	tab_material_box.add_child(preset_row)
	for pc in [Color("e0e0dc"), Color("d94f4f"), Color("e0864f"), Color("e0b64f"), 
			Color("58a862"), Color("4fa9a0"), Color("4f7dd9"), Color("7a5fd9"), 
			Color("c95f9e"), Color("8a6f52"), Color("777d88"), Color("333333")]:
		var swatch: = Button.new()
		swatch.custom_minimum_size = Vector2(30, 26)
		swatch.focus_mode = Control.FOCUS_NONE
		var sb: = StyleBoxFlat.new()
		sb.bg_color = pc
		sb.set_corner_radius_all(6)
		swatch.add_theme_stylebox_override("normal", sb)
		swatch.add_theme_stylebox_override("hover", sb)
		swatch.add_theme_stylebox_override("pressed", sb)
		var cc: Color = pc
		swatch.pressed.connect( func() -> void :
			_push_undo()
			scene_manager.set_selected_color(cc)
			color_btn.color = cc)
		preset_row.add_child(swatch)
	var reset_btn: = _make_button("还原配色", func() -> void :
		_push_undo()
		scene_manager.reset_selected_color()
		color_btn.color = scene_manager.get_selected_color()
		_status("已还原为原始配色"))
	tab_material_box.add_child(reset_btn)

	tab_light_box = VBoxContainer.new()
	tab_light_box.visible = false
	props_box.add_child(tab_light_box)
	var light_hint: = Label.new()
	light_hint.text = "灯光将在后续版本开放"
	light_hint.theme_type_variation = "DimLabel"
	tab_light_box.add_child(light_hint)


	pose_box = VBoxContainer.new()
	pose_box.add_theme_constant_override("separation", 6)
	pose_box.visible = false
	props_box.add_child(pose_box)
	var pose_head: = HBoxContainer.new()
	pose_box.add_child(pose_head)
	var pose_title: = Label.new()
	pose_title.text = "姿势预设"
	pose_title.theme_type_variation = "DimLabel"
	pose_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pose_head.add_child(pose_title)
	var pose_reset: = _make_button("↺ 重置", func() -> void : _apply_figure_pose("站立"))
	pose_reset.theme_type_variation = "GhostButton"
	pose_head.add_child(pose_reset)
	var pose_grid: = GridContainer.new()
	pose_grid.columns = 4
	pose_grid.add_theme_constant_override("h_separation", 4)
	pose_grid.add_theme_constant_override("v_separation", 4)
	pose_box.add_child(pose_grid)
	for pname in FigureLib.POSES:
		var pn: String = pname
		var chip: = _make_button(pn, func() -> void : _apply_figure_pose(pn))
		chip.theme_type_variation = "ToggleChip"
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		pose_grid.add_child(chip)

	var op_row: = HBoxContainer.new()
	op_row.add_theme_constant_override("separation", 6)
	props_box.add_child(op_row)
	op_row.add_child(_make_button("复制", func() -> void :
		_push_undo()
		scene_manager.duplicate_selected()))
	op_row.add_child(_make_button("删除", _delete_selected_object))
	op_row.add_child(_make_button("打组", _group_selected))
	op_row.add_child(_make_button("解组", _ungroup_selected))


func _apply_figure_pose(pose: String) -> void :
	var obj: = scene_manager.selected
	if obj == null or String(obj.get_meta("kind", "")) != "figure":
		return
	_push_undo()
	scene_manager.set_figure_pose(obj, pose)
	_status("姿势:" + pose)


func _show_props_tab(idx: int) -> void :
	tab_transform_box.visible = idx == 0
	tab_material_box.visible = idx == 1
	tab_light_box.visible = idx == 2


func _build_view_card(root: Control) -> void :
	view_card = PanelContainer.new()
	view_card.offset_left = 352
	view_card.offset_top = 56

	view_card.offset_right = 352
	view_card.offset_bottom = 56

	var vc_style: = StyleBoxFlat.new()
	vc_style.bg_color = Color(1, 1, 1, 0.35)
	vc_style.set_corner_radius_all(12)
	vc_style.border_color = Color(0.88, 0.9, 0.93, 0.4)
	vc_style.set_border_width_all(1)
	vc_style.content_margin_left = 12
	vc_style.content_margin_right = 12
	vc_style.content_margin_top = 4
	vc_style.content_margin_bottom = 4
	view_card.add_theme_stylebox_override("panel", vc_style)
	root.add_child(view_card)
	var box: = HBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	view_card.add_child(box)

	var seg: = PanelContainer.new()
	seg.theme_type_variation = "SegGroup"
	box.add_child(seg)
	var seg_box: = HBoxContainer.new()
	seg_box.add_theme_constant_override("separation", 2)
	seg.add_child(seg_box)
	var vgroup: = ButtonGroup.new()
	view_persp_btn = Button.new()
	view_persp_btn.text = "透视"
	view_persp_btn.toggle_mode = true
	view_persp_btn.button_group = vgroup
	view_persp_btn.button_pressed = true
	view_persp_btn.theme_type_variation = "SegDark"
	view_persp_btn.focus_mode = Control.FOCUS_NONE
	view_persp_btn.pressed.connect( func() -> void : _set_view("persp"))
	seg_box.add_child(view_persp_btn)
	view_two_btn = Button.new()
	view_two_btn.text = "二点透视"
	view_two_btn.toggle_mode = true
	view_two_btn.button_group = vgroup
	view_two_btn.theme_type_variation = "SegDark"
	view_two_btn.focus_mode = Control.FOCUS_NONE
	view_two_btn.pressed.connect( func() -> void : _set_view("two_point"))
	seg_box.add_child(view_two_btn)
	box.add_child(VSeparator.new())

	var fov_label: = Label.new()
	fov_label.text = "焦距"
	fov_label.theme_type_variation = "DimLabel"
	box.add_child(fov_label)
	fov_slider = HSlider.new()
	fov_slider.min_value = 15
	fov_slider.max_value = 100
	fov_slider.value = 60
	fov_slider.custom_minimum_size = Vector2(110, 0)
	fov_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	fov_slider.focus_mode = Control.FOCUS_NONE
	fov_slider.value_changed.connect( func(v: float) -> void :
		fly_cam.set_fov_deg(v)
		_update_fov_label())
	box.add_child(fov_slider)
	fov_value_label = Label.new()
	fov_value_label.theme_type_variation = "DimLabel"
	box.add_child(fov_value_label)
	_update_fov_label()
	box.add_child(VSeparator.new())

	var move_label: = Label.new()
	move_label.text = "移动"
	move_label.theme_type_variation = "DimLabel"
	move_label.tooltip_text = "拖动物体的灵敏度(小 = 更精细,不易跑飞)"
	box.add_child(move_label)
	var move_slider: = HSlider.new()
	move_slider.min_value = 0.2
	move_slider.max_value = 1.5
	move_slider.step = 0.05
	move_slider.value = drag_sensitivity
	move_slider.custom_minimum_size = Vector2(88, 0)
	move_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	move_slider.focus_mode = Control.FOCUS_NONE
	move_slider.tooltip_text = "拖动物体的灵敏度(小 = 更精细,不易跑飞)"
	move_slider.value_changed.connect( func(v: float) -> void :
		drag_sensitivity = v)
	box.add_child(move_slider)
	box.add_child(VSeparator.new())

	snap_check = Button.new()
	snap_check.text = "吸附"
	snap_check.toggle_mode = true
	snap_check.button_pressed = true
	snap_check.theme_type_variation = "ToggleChip"
	snap_check.focus_mode = Control.FOCUS_NONE
	box.add_child(snap_check)
	label_check = Button.new()
	label_check.text = "名称"
	label_check.toggle_mode = true
	label_check.button_pressed = true
	label_check.theme_type_variation = "ToggleChip"
	label_check.focus_mode = Control.FOCUS_NONE
	label_check.tooltip_text = "显示/隐藏物体头顶名称(近距离碍事时关掉)"
	label_check.toggled.connect( func(on: bool) -> void :
		scene_manager.set_labels_visible(on)
		_status("头顶名称:" + ("显示" if on else "隐藏")))
	box.add_child(label_check)
	blur_check = Button.new()
	blur_check.text = "运动模糊"
	blur_check.toggle_mode = true
	blur_check.button_pressed = motion_blur_on
	blur_check.theme_type_variation = "ToggleChip"
	blur_check.focus_mode = Control.FOCUS_NONE
	blur_check.tooltip_text = "相机移动时的拖影(布景精细摆放时可关掉)"
	blur_check.toggled.connect( func(on: bool) -> void :
		motion_blur_on = on
		if not on and blur_layer:
			blur_layer.visible = false
		_status("运动模糊:" + ("开" if on else "关")))
	box.add_child(blur_check)

	box.add_child(VSeparator.new())
	var fps_lbl: = Label.new()
	fps_lbl.text = "帧率"
	fps_lbl.theme_type_variation = "DimLabel"
	box.add_child(fps_lbl)
	fps_opt = OptionButton.new()
	fps_opt.focus_mode = Control.FOCUS_NONE
	fps_opt.tooltip_text = "导出帧率(fps)"
	fps_opt.get_popup().theme = ui_theme
	for i in range(FPS_OPTIONS.size()):
		fps_opt.add_item("%d" % FPS_OPTIONS[i], i)
	fps_opt.select(FPS_OPTIONS.find(shot_fps) if FPS_OPTIONS.has(shot_fps) else 2)
	fps_opt.item_selected.connect( func(i: int) -> void :
		shot_fps = FPS_OPTIONS[i]
		_status("导出帧率:%d fps" % shot_fps))
	box.add_child(fps_opt)

	box.add_child(VSeparator.new())
	fps_label = Label.new()
	fps_label.theme_type_variation = "DimLabel"
	fps_label.text = "-- FPS"
	box.add_child(fps_label)


func _build_right_panel(root: Control) -> void :
	right_panel = PanelContainer.new()
	right_panel.anchor_left = 1.0
	right_panel.anchor_right = 1.0
	right_panel.anchor_top = 0.0
	right_panel.anchor_bottom = 1.0
	right_panel.offset_left = -352
	right_panel.offset_right = 0
	right_panel.offset_top = 60
	right_panel.offset_bottom = 0
	root.add_child(right_panel)

	var box: = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	right_panel.add_child(box)


	var tab_seg: = PanelContainer.new()
	tab_seg.theme_type_variation = "SegGroup"
	box.add_child(tab_seg)
	var tab_box: = HBoxContainer.new()
	tab_box.add_theme_constant_override("separation", 2)
	tab_seg.add_child(tab_box)
	var group: = ButtonGroup.new()
	var names: = ["工具", "素材库"]
	for i in range(2):
		var tb: = Button.new()
		tb.text = names[i]
		tb.toggle_mode = true
		tb.button_group = group
		tb.button_pressed = i == 0
		tb.theme_type_variation = "SegButton"
		tb.focus_mode = Control.FOCUS_NONE
		tb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var idx: = i
		tb.pressed.connect( func() -> void :
			right_tab_tools.visible = idx == 0
			right_tab_assets.visible = idx == 1)
		tab_box.add_child(tb)


	right_tab_tools = VBoxContainer.new()
	right_tab_tools.add_theme_constant_override("separation", 6)
	right_tab_tools.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(right_tab_tools)
	var geo_title: = Label.new()
	geo_title.text = "几何体"
	geo_title.theme_type_variation = "DimLabel"
	right_tab_tools.add_child(geo_title)
	var geo_grid: = GridContainer.new()
	geo_grid.columns = 3
	geo_grid.add_theme_constant_override("h_separation", 6)
	geo_grid.add_theme_constant_override("v_separation", 6)
	right_tab_tools.add_child(geo_grid)
	for kind in SceneManager.KINDS:
		var k: String = kind
		geo_grid.add_child(_make_asset_card(
			SceneManager.KINDS[kind], _thumb_texture("prim_" + k), 
			func() -> void : _spawn_primitive(k)))
	var fig_title: = Label.new()
	fig_title.text = "人物(关节人偶 · 选中后可换姿势)"
	fig_title.theme_type_variation = "DimLabel"
	right_tab_tools.add_child(fig_title)
	var fig_grid: = GridContainer.new()
	fig_grid.columns = 3
	fig_grid.add_theme_constant_override("h_separation", 6)
	fig_grid.add_theme_constant_override("v_separation", 6)
	right_tab_tools.add_child(fig_grid)
	for ft in FigureLib.BODY_TYPES:
		var ftype: String = ft
		var fcn: = String(FigureLib.BODY_TYPES[ft].cn)
		fig_grid.add_child(_make_asset_card(fcn, 
			_thumb_texture("prim_figure_" + ftype), 
			func() -> void : _spawn_figure(ftype)))
	fig_grid.add_child(_make_asset_card("群众阵列…", 
		_thumb_texture("prim_figure_standard"), 
		func() -> void : crowd_dialog.popup_centered()))

	var tool_hint: = Label.new()
	tool_hint.text = "WASD/QE 飞行 · 右键 转视角\n左键 选中/拖动 · 拖 XYZ 轴精确移动\n拖圆环旋转 · [ ] 快转 · Del 删 · Ctrl+C 复制 · Ctrl+Z 撤销"


	tool_hint.theme_type_variation = "DimLabel"
	right_tab_tools.add_child(tool_hint)


	right_tab_assets = VBoxContainer.new()
	right_tab_assets.add_theme_constant_override("separation", 6)
	right_tab_assets.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_tab_assets.visible = false
	box.add_child(right_tab_assets)
	lib_cat_opt = OptionButton.new()
	lib_cat_opt.focus_mode = Control.FOCUS_NONE
	lib_cat_opt.add_item("全部分类(%d)" % model_lookup.size())
	for c in model_index.get("categories", []):
		lib_cat_opt.add_item(String(c.cn))
	lib_cat_opt.item_selected.connect( func(_i: int) -> void : _refresh_library_list())
	right_tab_assets.add_child(lib_cat_opt)
	lib_search = LineEdit.new()
	lib_search.placeholder_text = "搜索模型…"
	lib_search.clear_button_enabled = true
	lib_search.text_changed.connect( func(_t: String) -> void : _refresh_library_list())
	right_tab_assets.add_child(lib_search)
	var scroll: = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	right_tab_assets.add_child(scroll)
	lib_grid = GridContainer.new()
	lib_grid.columns = 3
	lib_grid.add_theme_constant_override("h_separation", 6)
	lib_grid.add_theme_constant_override("v_separation", 6)
	lib_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(lib_grid)
	_refresh_library_list()



func _make_asset_card(label_text: String, tex: Texture2D, on_pressed: Callable) -> Button:
	var btn: = Button.new()
	btn.theme_type_variation = "AssetCard"
	btn.focus_mode = Control.FOCUS_NONE
	btn.custom_minimum_size = Vector2(92, 96)
	btn.text = label_text
	btn.clip_text = true
	btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
	if tex:
		btn.icon = tex
		btn.expand_icon = true
		btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	btn.pressed.connect(on_pressed)
	return btn


func _refresh_library_list() -> void :
	if not lib_grid:
		return
	for c in lib_grid.get_children():
		lib_grid.remove_child(c)
		c.queue_free()
	var cats: Array = model_index.get("categories", [])
	var cat_key: = ""
	var sel: = lib_cat_opt.selected
	if sel > 0 and sel <= cats.size():
		cat_key = String(cats[sel - 1].key)
	var query: = lib_search.text.strip_edges().to_lower()
	var shown: = 0
	for m in model_index.get("models", []):
		if not cat_key.is_empty() and String(m.cat) != cat_key:
			continue
		var cn: = String(m.get("cn", m.id))
		if not query.is_empty() and cn.to_lower().find(query) < 0\
		and String(m.id).to_lower().find(query) < 0:
			continue
		var entry: Dictionary = m
		lib_grid.add_child(_make_asset_card(cn, _thumb_texture(String(m.id)), 
			func() -> void : _spawn_model(entry)))
		shown += 1
		if shown >= 150:
			break


func _refresh_object_list() -> void :
	if not obj_list_box:
		return
	for c in obj_list_box.get_children():
		obj_list_box.remove_child(c)
		c.queue_free()
	for obj in scene_manager.list_objects():
		var row: = HBoxContainer.new()
		row.add_theme_constant_override("separation", 2)
		var target: Node3D = obj
		var kind: String = obj.get_meta("kind", "box")
		var sel_btn: = Button.new()
		sel_btn.text = "%s  %s" % [KIND_ICONS.get(kind, "▢"), String(obj.name)]
		sel_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		sel_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sel_btn.focus_mode = Control.FOCUS_NONE
		sel_btn.theme_type_variation = "RowSelected"\
		if scene_manager.selected_list.has(obj) else "GhostButton"
		sel_btn.pressed.connect( func() -> void :
			scene_manager.select(target))
		row.add_child(sel_btn)
		var eye: = Button.new()
		eye.text = "👁" if obj.visible else "—"
		eye.theme_type_variation = "GhostButton"
		eye.focus_mode = Control.FOCUS_NONE
		eye.tooltip_text = "显示/隐藏(隐藏的物体不进成片)"
		eye.pressed.connect( func() -> void :
			target.visible = not target.visible
			_refresh_object_list())
		row.add_child(eye)
		var more: = MenuButton.new()
		more.text = "⋮"
		more.focus_mode = Control.FOCUS_NONE
		var mpop: = more.get_popup()
		mpop.theme = ui_theme
		mpop.add_item("复制", 0)
		mpop.add_item("删除", 1)
		mpop.id_pressed.connect( func(id: int) -> void :
			scene_manager.select(target)
			if id == 0:
				_push_undo()
				scene_manager.duplicate_selected()
			else:
				_delete_selected_object())
		row.add_child(more)
		obj_list_box.add_child(row)


func _add_vec_row(grid_c: GridContainer, label_text: String, prefix: String, 
		vmin: float, vmax: float, step: float) -> void :
	if prefix == "s":
		var lock: = Button.new()
		lock.text = label_text + "🔗"
		lock.toggle_mode = true
		lock.button_pressed = true
		lock.theme_type_variation = "ToggleChip"
		lock.focus_mode = Control.FOCUS_NONE
		lock.tooltip_text = "统一缩放(默认锁定;解锁后可单独改 XYZ)"
		lock.toggled.connect( func(on: bool) -> void :
			scale_lock = on
			lock.text = label_text + ("🔗" if on else "✂"))
		grid_c.add_child(lock)
	else:
		var lb: = Label.new()
		lb.text = label_text
		lb.custom_minimum_size = Vector2(34, 0)
		grid_c.add_child(lb)
	for axis in ["x", "y", "z"]:
		var sp: = SpinBox.new()
		sp.min_value = vmin
		sp.max_value = vmax
		sp.step = step
		sp.prefix = axis.to_upper()
		sp.custom_minimum_size = Vector2(58, 0)
		sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var key: String = prefix + axis
		sp.value_changed.connect( func(v: float) -> void : _on_spin_changed(key, v))
		grid_c.add_child(sp)
		_spin[key] = sp


func _on_spin_changed(key: String, v: float) -> void :
	if _insp_updating or not scene_manager.selected:
		return
	if key.begins_with("s") and scale_lock:
		_insp_updating = true
		_spin.sx.set_value_no_signal(v)
		_spin.sy.set_value_no_signal(v)
		_spin.sz.set_value_no_signal(v)
		_insp_updating = false
	_inspector_changed()


func _build_bottom_card(root: Control) -> void :
	bottom_card = PanelContainer.new()
	bottom_card.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom_card.offset_left = 352
	bottom_card.offset_right = 0
	bottom_card.offset_top = -300
	bottom_card.offset_bottom = 0
	root.add_child(bottom_card)

	var root_box: = HBoxContainer.new()
	root_box.add_theme_constant_override("separation", 14)
	bottom_card.add_child(root_box)


	var left_col: = VBoxContainer.new()
	left_col.add_theme_constant_override("separation", 8)
	left_col.alignment = BoxContainer.ALIGNMENT_CENTER
	root_box.add_child(left_col)
	var rail_title: = Label.new()
	rail_title.text = "镜头轨道"
	rail_title.theme_type_variation = "DimLabel"
	left_col.add_child(rail_title)


	var mode_seg: = PanelContainer.new()
	mode_seg.theme_type_variation = "SegGroup"
	left_col.add_child(mode_seg)
	var mode_box: = HBoxContainer.new()
	mode_box.add_theme_constant_override("separation", 2)
	mode_seg.add_child(mode_box)
	var mgroup: = ButtonGroup.new()
	track_mode_auto_btn = Button.new()
	track_mode_auto_btn.text = "自动"
	track_mode_auto_btn.toggle_mode = true
	track_mode_auto_btn.button_group = mgroup
	track_mode_auto_btn.button_pressed = true
	track_mode_auto_btn.theme_type_variation = "SegButton"
	track_mode_auto_btn.focus_mode = Control.FOCUS_NONE
	track_mode_auto_btn.pressed.connect( func() -> void : _set_track_mode(true))
	mode_box.add_child(track_mode_auto_btn)
	track_mode_manual_btn = Button.new()
	track_mode_manual_btn.text = "手动"
	track_mode_manual_btn.toggle_mode = true
	track_mode_manual_btn.button_group = mgroup
	track_mode_manual_btn.theme_type_variation = "SegButton"
	track_mode_manual_btn.focus_mode = Control.FOCUS_NONE
	track_mode_manual_btn.pressed.connect( func() -> void : _set_track_mode(false))
	mode_box.add_child(track_mode_manual_btn)
	play_btn = _make_button("▶", _toggle_play)
	play_btn.theme_type_variation = "PlayBig"
	play_btn.custom_minimum_size = Vector2(56, 56)
	var play_center: = CenterContainer.new()
	play_center.add_child(play_btn)
	left_col.add_child(play_center)
	time_label = Label.new()
	time_label.theme_type_variation = "DimLabel"
	left_col.add_child(time_label)
	_update_time_label()

	var box: = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_child(box)


	var strip_scroll: = ScrollContainer.new()
	strip_scroll.custom_minimum_size = Vector2(0, 58)
	strip_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(strip_scroll)
	clip_strip = HBoxContainer.new()
	clip_strip.add_theme_constant_override("separation", 6)
	strip_scroll.add_child(clip_strip)


	var hh_row: = HBoxContainer.new()
	hh_row.add_theme_constant_override("separation", 8)
	box.add_child(hh_row)
	handheld_check = Button.new()
	handheld_check.text = "🎥 手持运镜"
	handheld_check.toggle_mode = true
	handheld_check.theme_type_variation = "ToggleChip"
	handheld_check.focus_mode = Control.FOCUS_NONE
	handheld_check.tooltip_text = "给相机叠加自然抖动,模拟手持拍摄(播放/导出生效)"
	handheld_check.toggled.connect( func(on: bool) -> void :
		_shot()["handheld"] = _handheld_amp if on else 0.0
		_status("手持运镜:" + ("开(强度 %d%%),按空格预览" % int(_handheld_amp * 100)\
		if on else "关")))
	hh_row.add_child(handheld_check)
	var hh_label: = Label.new()
	hh_label.text = "强度"
	hh_label.theme_type_variation = "DimLabel"
	hh_row.add_child(hh_label)
	handheld_slider = HSlider.new()
	handheld_slider.min_value = 0.15
	handheld_slider.max_value = 1.0
	handheld_slider.step = 0.05
	handheld_slider.value = _handheld_amp
	handheld_slider.custom_minimum_size = Vector2(120, 0)
	handheld_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	handheld_slider.focus_mode = Control.FOCUS_NONE
	handheld_slider.tooltip_text = "抖动幅度:轻微(晃)→ 强烈(纪录片手持感)"
	handheld_slider.value_changed.connect( func(v: float) -> void :
		_handheld_amp = v
		handheld_check.set_pressed_no_signal(true)
		_shot()["handheld"] = v)
	hh_row.add_child(handheld_slider)
	var hh_sp: = Control.new()
	hh_sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hh_row.add_child(hh_sp)


	auto_row = HBoxContainer.new()
	auto_row.add_theme_constant_override("separation", 8)
	box.add_child(auto_row)
	var rec_btn: = _make_button("📍 记下这个机位 (K)", _record_waypoint)
	rec_btn.theme_type_variation = "PrimaryButton"
	rec_btn.custom_minimum_size = Vector2(220, 40)
	auto_row.add_child(rec_btn)
	auto_row.add_child(_make_button("撤销上点", _undo_waypoint))
	auto_row.add_child(_make_button("清空重来", _clear_waypoints))
	auto_count_label = Label.new()
	auto_count_label.theme_type_variation = "DimLabel"
	auto_count_label.text = "已记 0 点"
	auto_row.add_child(auto_count_label)
	auto_row.add_child(VSeparator.new())
	var auto_dur_label: = Label.new()
	auto_dur_label.text = "总时长"
	auto_dur_label.theme_type_variation = "DimLabel"
	auto_row.add_child(auto_dur_label)
	auto_dur_spin = SpinBox.new()
	auto_dur_spin.min_value = 1.0
	auto_dur_spin.max_value = 120.0
	auto_dur_spin.step = 0.5
	auto_dur_spin.value = 8.0
	auto_dur_spin.suffix = "s"
	auto_dur_spin.tooltip_text = "总时长 = 最后一个机位点的时刻(自动跟随);改它只把末点挪到这个秒数,不压缩其它点"
	auto_dur_spin.value_changed.connect( func(v: float) -> void :
		_set_total_duration(v))
	auto_row.add_child(auto_dur_spin)
	var auto_hint: = Label.new()
	auto_hint.text = "飞到想要的画面 → 按 K · 每按一次自动接上一段"
	auto_hint.theme_type_variation = "DimLabel"
	auto_hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	auto_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	auto_row.add_child(auto_hint)


	wp_scroll = ScrollContainer.new()
	wp_scroll.custom_minimum_size = Vector2(0, 84)
	wp_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(wp_scroll)
	wp_strip = HBoxContainer.new()
	wp_strip.add_theme_constant_override("separation", 6)
	wp_scroll.add_child(wp_strip)


	var row: = HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	box.add_child(row)
	manual_row = row
	row.add_child(_make_button("⏮", func() -> void :
		playhead = 0.0
		playing = false
		_sync_play_btn()
		_apply_at(0.0)
		timeline.playhead = 0.0
		_update_time_label()))
	row.add_child(_make_button("◀", func() -> void : _jump_to_key(-1)))
	row.add_child(_make_button("▶|", func() -> void : _jump_to_key(1)))
	loop_check = Button.new()
	loop_check.text = "循环"
	loop_check.toggle_mode = true
	loop_check.theme_type_variation = "ToggleChip"
	loop_check.focus_mode = Control.FOCUS_NONE
	row.add_child(loop_check)
	pause_key_check = Button.new()
	pause_key_check.text = "遇帧停"
	pause_key_check.toggle_mode = true
	pause_key_check.theme_type_variation = "ToggleChip"
	pause_key_check.focus_mode = Control.FOCUS_NONE
	row.add_child(pause_key_check)
	row.add_child(VSeparator.new())
	var dur_label: = Label.new()
	dur_label.text = "时长"
	dur_label.theme_type_variation = "DimLabel"
	row.add_child(dur_label)
	duration_spin = SpinBox.new()
	duration_spin.min_value = 1.0
	duration_spin.max_value = 120.0
	duration_spin.step = 0.5
	duration_spin.value = 8.0
	duration_spin.value_changed.connect( func(v: float) -> void :
		_shot()["duration"] = v
		timeline.duration = v
		playhead = minf(playhead, v)
		_update_time_label()
		_refresh_clip_strip())
	row.add_child(duration_spin)
	var sp: = Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(sp)
	row.add_child(_make_button("K 相机帧", _add_camera_keyframe))
	row.add_child(_make_button("J 物体帧", _add_object_keyframe))
	row.add_child(_make_button("删镜帧", func() -> void : _delete_key_near(_cam_kf(), "相机")))
	row.add_child(_make_button("删物帧", func() -> void :
		var obj: = scene_manager.selected
		if obj == null:
			_status("先选中物体")
			return
		_delete_key_near(_obj_kf().get(String(obj.name), []), "物体")))


	timeline = TimelinePanel.new()
	timeline.size_flags_vertical = Control.SIZE_EXPAND_FILL
	timeline.scrubbed.connect( func(t: float) -> void :
		playhead = t
		playing = false
		_sync_play_btn()
		_apply_at(t)
		_update_time_label())
	box.add_child(timeline)
	_set_track_mode(auto_mode)


func _build_status(root: Control) -> void :
	status_chip = PanelContainer.new()
	status_chip.theme_type_variation = "Chip"
	status_chip.anchor_top = 1.0
	status_chip.anchor_bottom = 1.0
	status_chip.offset_left = 360
	status_chip.offset_top = -52
	status_chip.offset_bottom = -12
	root.add_child(status_chip)
	status_label = Label.new()
	status_label.text = "布景模式:右侧「工具/素材库」添加物体,左键拖动摆放"
	status_chip.add_child(status_label)



func _update_left_panels() -> void :
	if shoot_mode:
		var has_sel: = scene_manager.selected != null and is_instance_valid(scene_manager.selected)
		layout_left_panel.visible = has_sel
		shoot_left_panel.visible = not has_sel
	else:
		layout_left_panel.visible = true
		shoot_left_panel.visible = false


func _set_mode(shoot: bool) -> void :
	shoot_mode = shoot
	_update_left_panels()
	bottom_card.visible = shoot
	if frame_overlay:
		frame_overlay.visible = true
		_update_frame_safe_rect.call_deferred()
	right_panel.visible = not shoot
	bottom_card.offset_right = 0 if shoot else -352
	mode_card_layout.set_pressed_no_signal( not shoot)
	mode_card_shoot.set_pressed_no_signal(shoot)
	if shoot:
		_sync_shot_ui()
		status_chip.offset_top = bottom_card.offset_top - 48.0
		status_chip.offset_bottom = bottom_card.offset_top - 8.0
		_status("拍摄模式:飞好机位按 K;或左侧选预制镜头一键运镜;J 给选中物体打帧")
	else:
		playing = false
		_sync_play_btn()
		status_chip.offset_top = -52
		status_chip.offset_bottom = -12
		_status("布景模式:右侧「工具/素材库」添加物体,左键拖动摆放")


func _build_dialogs(root: Control) -> void :
	_save_dialog = _make_file_dialog(FileDialog.FILE_MODE_SAVE_FILE, 
		PackedStringArray(["*.json ; 预演工程"]), "工程.json", 
		func(path: String) -> void :
			var p: = path
			if not p.ends_with(".json"):
				p += ".json"
			_save_project_to(p)
			_set_project_path(p)
			_add_recent(p)
			_status("已保存:" + p))
	root.add_child(_save_dialog)

	_open_dialog = _make_file_dialog(FileDialog.FILE_MODE_OPEN_FILE, 
		PackedStringArray(["*.json ; 预演工程"]), "", 
		func(path: String) -> void :
			if _load_project_from(path):
				_set_project_path(path)
				_add_recent(path)
				_status("已打开:" + path)
				_apply_at(0.0)
			else:
				_status("打开失败:文件格式不对"))
	root.add_child(_open_dialog)

	_export_dialog = _make_file_dialog(FileDialog.FILE_MODE_SAVE_FILE, 
		PackedStringArray(["*.mp4 ; 视频文件"]), "段落1.mp4", 
		func(path: String) -> void : _start_export(path))
	root.add_child(_export_dialog)

	_still_dialog = _make_file_dialog(FileDialog.FILE_MODE_SAVE_FILE, 
		PackedStringArray(["*.png ; 图片"]), "画面.png", 
		func(path: String) -> void : _export_still(path))
	root.add_child(_still_dialog)


	band_rect = Panel.new()
	var band_style: = StyleBoxFlat.new()
	band_style.bg_color = Color(0.4, 0.45, 0.95, 0.1)
	band_style.border_color = Color(0.4, 0.45, 0.95, 0.8)
	band_style.set_border_width_all(1)
	band_rect.add_theme_stylebox_override("panel", band_style)
	band_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	band_rect.visible = false
	root.add_child(band_rect)


	rename_dialog = ConfirmationDialog.new()
	rename_dialog.title = "重命名"
	rename_dialog.theme = ui_theme
	rename_dialog.ok_button_text = "确定"
	rename_dialog.cancel_button_text = "取消"
	rename_edit = LineEdit.new()
	rename_edit.placeholder_text = "输入新名称"
	rename_edit.custom_minimum_size = Vector2(300, 0)
	rename_dialog.add_child(rename_edit)
	rename_dialog.register_text_enter(rename_edit)
	rename_dialog.confirmed.connect( func() -> void :
		_rename_selected_object(rename_edit.text.strip_edges()))
	root.add_child(rename_dialog)


	update_dialog = ConfirmationDialog.new()
	update_dialog.theme = ui_theme
	update_dialog.ok_button_text = "立即更新"
	update_dialog.cancel_button_text = "稍后"
	update_dialog.confirmed.connect( func() -> void :
		updater.apply_update(_update_info))
	root.add_child(update_dialog)


	crowd_dialog = ConfirmationDialog.new()
	crowd_dialog.title = "添加群众阵列"
	crowd_dialog.theme = ui_theme
	crowd_dialog.ok_button_text = "添加"
	crowd_dialog.cancel_button_text = "取消"
	var crowd_box: = VBoxContainer.new()
	crowd_box.add_theme_constant_override("separation", 10)
	crowd_dialog.add_child(crowd_box)
	var rc_row: = HBoxContainer.new()
	rc_row.add_theme_constant_override("separation", 8)
	crowd_box.add_child(rc_row)
	var r_label: = Label.new()
	r_label.text = "行"
	rc_row.add_child(r_label)
	_crowd_rows = SpinBox.new()
	_crowd_rows.min_value = 1
	_crowd_rows.max_value = 20
	_crowd_rows.value = 1
	rc_row.add_child(_crowd_rows)
	var c_label: = Label.new()
	c_label.text = "× 列"
	rc_row.add_child(c_label)
	_crowd_cols = SpinBox.new()
	_crowd_cols.min_value = 1
	_crowd_cols.max_value = 20
	_crowd_cols.value = 3
	rc_row.add_child(_crowd_cols)
	var gap_row: = HBoxContainer.new()
	gap_row.add_theme_constant_override("separation", 8)
	crowd_box.add_child(gap_row)
	var gap_label: = Label.new()
	gap_label.text = "间距(米)"
	gap_row.add_child(gap_label)
	_crowd_gap = SpinBox.new()
	_crowd_gap.min_value = 0.5
	_crowd_gap.max_value = 5.0
	_crowd_gap.step = 0.1
	_crowd_gap.value = 1.2
	gap_row.add_child(_crowd_gap)
	_crowd_count_label = Label.new()
	_crowd_count_label.theme_type_variation = "DimLabel"
	_crowd_count_label.text = "共 3 人"
	crowd_box.add_child(_crowd_count_label)
	var update_count: = func(_v: float) -> void :
		_crowd_count_label.text = "共 %d 人" % int(_crowd_rows.value * _crowd_cols.value)
	_crowd_rows.value_changed.connect(update_count)
	_crowd_cols.value_changed.connect(update_count)
	crowd_dialog.confirmed.connect( func() -> void :
		_spawn_crowd_grid(int(_crowd_rows.value), int(_crowd_cols.value), 
			_crowd_gap.value))
	root.add_child(crowd_dialog)


	preview_dialog = ConfirmationDialog.new()
	preview_dialog.theme = ui_theme
	preview_dialog.ok_button_text = "套用到当前段落"
	preview_dialog.cancel_button_text = "关闭"
	_dialog_rect = TextureRect.new()
	_dialog_rect.custom_minimum_size = Vector2(520, 292)
	_dialog_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_dialog_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_dialog.add_child(_dialog_rect)
	preview_dialog.confirmed.connect( func() -> void :
		_apply_camera_preset(_dialog_key, _dialog_cn))
	root.add_child(preview_dialog)

	help_dialog = AcceptDialog.new()
	help_dialog.title = "操作说明"
	help_dialog.theme = ui_theme
	help_dialog.dialog_text = "相机:WASD/QE 飞行(不会飞到地面下),Shift 加速,右键按住转视角,滚轮推拉/调速\n视角:5 透视 · 2 二点透视 · 7 顶视图 · 1 前视图 · 3 右视图\n物体:左键选中/拖动 · 拖 XYZ 彩色箭头移动 · 拖彩色圆环旋转 · 拖橙色方块缩放 · 双击改名\n　　　拖太快?顶栏「移动」滑块调灵敏度 · [ ] 键或右侧「转向」按钮快转 · 解锁🔗改 XYZ 缩放\n　　　[ ] 旋转 · Del 删除 · Ctrl+C 复制 · Ctrl+Z 撤销\n多选:Ctrl+点击 加选 · Ctrl+空白处拖动 框选\n组:Ctrl+G 打组(整体移动/打帧)· Ctrl+Shift+G 解组\n关键帧:K 相机帧 · J 物体帧 · 预制镜头一键套用\n播放:空格 从当前段连播到最后 · Home 回起点 · Ctrl+S 保存\n导出:导出 MP4(本段视频)· 导出画面(当前视角 PNG,无 UI)"









	root.add_child(help_dialog)


	new_dialog = ConfirmationDialog.new()
	new_dialog.title = "新建工程"
	new_dialog.theme = ui_theme
	new_dialog.dialog_text = "将清空当前所有物体与段落,重新开始。\n未保存的内容会丢失,确定吗?"
	new_dialog.ok_button_text = "新建"
	new_dialog.cancel_button_text = "取消"
	new_dialog.confirmed.connect(_new_project)
	root.add_child(new_dialog)


	for d: Window in [rename_dialog, update_dialog, crowd_dialog, 
			preview_dialog, help_dialog, new_dialog]:
		UITheme.style_dialog(d)


func _make_file_dialog(mode: int, filters: PackedStringArray, default_name: String, 
		callback: Callable) -> FileDialog:
	var dlg: = FileDialog.new()
	dlg.file_mode = mode
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.filters = filters
	dlg.use_native_dialog = true
	if not default_name.is_empty():
		dlg.current_file = default_name
	dlg.file_selected.connect(callback)
	return dlg


func _make_button(text: String, on_pressed: Callable) -> Button:
	var btn: = Button.new()
	btn.text = text
	btn.focus_mode = Control.FOCUS_NONE
	btn.pressed.connect(on_pressed)
	return btn


func _update_fov_label() -> void :
	if fov_value_label:
		fov_value_label.text = "%d°" % int(fly_cam.fov_deg)


func _status(msg: String) -> void :
	print("[状态] " + msg)
	if status_label:
		status_label.text = msg
		status_chip.reset_size()




func _refresh_inspector() -> void :
	var obj: = scene_manager.selected
	if props_box:
		props_box.visible = obj != null
	if pose_box:
		pose_box.visible = obj != null\
		and String(obj.get_meta("kind", "")) == "figure"
	if obj:
		_refresh_inspector_values()


func _refresh_inspector_values() -> void :
	var obj: = scene_manager.selected
	if not obj:
		return
	_insp_updating = true
	name_edit.text = String(obj.name)
	_spin.px.set_value_no_signal(obj.position.x)
	_spin.py.set_value_no_signal(obj.position.y)
	_spin.pz.set_value_no_signal(obj.position.z)
	_spin.rx.set_value_no_signal(obj.rotation_degrees.x)
	_spin.ry.set_value_no_signal(obj.rotation_degrees.y)
	_spin.rz.set_value_no_signal(obj.rotation_degrees.z)
	_spin.sx.set_value_no_signal(obj.scale.x)
	_spin.sy.set_value_no_signal(obj.scale.y)
	_spin.sz.set_value_no_signal(obj.scale.z)
	color_btn.color = scene_manager.get_selected_color()
	_insp_updating = false


func _inspector_changed() -> void :
	if _insp_updating or not scene_manager.selected:
		return
	var obj: = scene_manager.selected
	obj.position = Vector3(_spin.px.value, _spin.py.value, _spin.pz.value)
	obj.rotation_degrees = Vector3(_spin.rx.value, _spin.ry.value, _spin.rz.value)
	obj.scale = Vector3(_spin.sx.value, _spin.sy.value, _spin.sz.value)
	scene_manager.refresh_labels()





func _run_build_index() -> void :
	print("BUILD-INDEX: 开始测量 %d 个模型" % model_lookup.size())
	var models: Array = model_index.get("models", [])
	var by_cat: Dictionary = {}
	for m in models:
		var ps: = load(String(m.file)) as PackedScene
		if ps == null:
			print("  加载失败: " + String(m.file))
			continue
		var inst: = ps.instantiate()
		add_child(inst)
		var aabb: = SceneManager.combined_aabb(inst)
		remove_child(inst)
		inst.free()
		m["aabb"] = [aabb.size.x, aabb.size.y, aabb.size.z]
		m["min_y"] = aabb.position.y
		var cat: = String(m.cat)
		if not by_cat.has(cat):
			by_cat[cat] = []
		(by_cat[cat] as Array).append(m)
	var scale_of: = {}
	scale_of["vehicle"] = _scale_by_ref(by_cat, "vehicle/sedan", "xz", 4.4)
	scale_of["house"] = _scale_by_median(by_cat, "house", "y", 5.5)
	scale_of["building"] = scale_of["house"]
	scale_of["road"] = scale_of["house"]
	scale_of["medieval"] = _scale_by_median(by_cat, "medieval", "y", 4.0)
	scale_of["furniture"] = _scale_by_median(by_cat, "furniture", "y", 0.85)
	scale_of["nature"] = _scale_by_median_prefix(by_cat, "nature", "nature/tree", "y", 6.0)
	for c in model_index.get("categories", []):
		c["scale"] = snappedf(float(scale_of.get(String(c.key), 1.0)), 0.001)
		print("  类别 %s 缩放 = %.3f" % [String(c.key), float(c.scale)])
	var f: = FileAccess.open("res://models_index.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(model_index, " "))
	f.flush()
	print("BUILD-INDEX: 完成")
	get_tree().quit(0)


func _dim_of(m: Dictionary, dim: String) -> float:
	var s: Array = m.get("aabb", [1, 1, 1])
	match dim:
		"y":
			return float(s[1])
		"xz":
			return maxf(float(s[0]), float(s[2]))
	return float(s[1])


func _scale_by_ref(by_cat: Dictionary, ref_id: String, dim: String, target: float) -> float:
	var cat: = ref_id.get_slice("/", 0)
	for m in by_cat.get(cat, []):
		if String(m.id) == ref_id:
			return target / maxf(_dim_of(m, dim), 0.001)
	return _scale_by_median(by_cat, cat, dim, target)


func _scale_by_median(by_cat: Dictionary, cat: String, dim: String, target: float) -> float:
	return _scale_by_median_prefix(by_cat, cat, "", dim, target)


func _scale_by_median_prefix(by_cat: Dictionary, cat: String, prefix: String, 
		dim: String, target: float) -> float:
	var vals: = []
	for m in by_cat.get(cat, []):
		if prefix.is_empty() or String(m.id).begins_with(prefix):
			vals.append(_dim_of(m, dim))
	if vals.is_empty():
		return 1.0
	vals.sort()
	var median: float = vals[vals.size() / 2]
	return target / maxf(median, 0.001)



func _run_build_thumbs() -> void :
	print("BUILD-THUMBS: 开始")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://thumbs"))
	thumb_vp.size = Vector2i(128, 128)
	scene_manager.labels_visible = false
	var far: = Vector3(4000, 0, 4000)

	for kind in SceneManager.KINDS:
		var obj: = scene_manager.add_primitive(String(kind), far)
		await _shoot_thumb(obj, "prim_" + String(kind))
		obj.free()

	for ft in FigureLib.BODY_TYPES:
		var fig: = scene_manager.add_figure(far, String(ft))
		await _shoot_thumb(fig, "prim_figure_" + String(ft))
		fig.free()

	var models: Array = model_index.get("models", [])
	var done: = 0
	for m in models:
		var info: Dictionary = model_lookup.get(String(m.id), {})
		if info.is_empty():
			continue
		var obj: = scene_manager.add_model(info.entry, float(info.cat_scale), far)
		if obj == null:
			continue
		await _shoot_thumb(obj, String(m.id).replace("/", "_"))
		obj.free()
		done += 1
		if done % 50 == 0:
			print("  已完成 %d/%d" % [done, models.size()])
	print("BUILD-THUMBS: 完成 %d 张" % (done + SceneManager.KINDS.size()))
	get_tree().quit(0)


func _shoot_thumb(obj: Node3D, thumb_id: String) -> void :
	var aabb: = scene_manager.get_local_aabb(obj)
	var center: Vector3 = obj.global_transform * aabb.get_center()
	var radius: = maxf(aabb.size.length() * obj.scale.x * 0.5, 0.4)
	var dir: = Vector3(1.0, 0.7, 1.4).normalized()
	thumb_cam.fov = 32.0
	thumb_cam.global_position = center + dir * (radius / tan(deg_to_rad(16.0)) * 1.06)
	thumb_cam.look_at(center)
	thumb_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	await get_tree().process_frame
	thumb_vp.get_texture().get_image().save_png(
		ProjectSettings.globalize_path("res://thumbs/%s.png" % thumb_id))



func _run_build_previews() -> void :
	print("BUILD-PREVIEWS: 开始 %d 个" % CAM_PRESETS.size())
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://previews"))
	scene_manager.labels_visible = false

	scene_manager.add_figure(Vector3.ZERO)
	scene_manager.add_primitive("box", Vector3(2.2, 0, -1.5))
	scene_manager.add_primitive("cylinder", Vector3(-2.0, 0, -2.2))
	scene_manager.add_primitive("box", Vector3(-1.5, 0, 1.8))
	scene_manager.select(null)
	thumb_vp.size = Vector2i(160, 90)
	var frames: = 12
	var ctx: = {
		"target": Vector3(0, 0.9, 0), 
		"cur": Vector3(4.2, 1.8, 4.2), 
		"fov0": 55.0, 
		"D": 2.0, 
	}
	var done: = 0
	for p in CAM_PRESETS:
		var keys: = _generate_preset_keys(String(p.key), ctx)
		if keys.is_empty():
			print("  跳过(无生成器): " + String(p.key))
			continue
		var sheet: = Image.create(160 * frames, 90, false, Image.FORMAT_RGB8)
		for i in range(frames):
			var s: = _sample_keys(keys, 2.0 * float(i) / (frames - 1))
			thumb_cam.global_transform = Transform3D(
				Basis(s.rot as Quaternion), s.pos as Vector3)
			thumb_cam.set_perspective(float(s.get("fov", 55.0)), 0.05, 4000.0)
			thumb_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
			await RenderingServer.frame_post_draw
			await get_tree().process_frame
			var img: = thumb_vp.get_texture().get_image()
			img.convert(Image.FORMAT_RGB8)
			sheet.blit_rect(img, Rect2i(0, 0, 160, 90), Vector2i(i * 160, 0))
		sheet.save_png(ProjectSettings.globalize_path(
			"res://previews/%s.png" % String(p.key)))
		done += 1
		if done % 10 == 0:
			print("  已完成 %d" % done)
	scene_manager.clear_objects()
	print("BUILD-PREVIEWS: 完成 %d 个" % done)
	get_tree().quit(0)



func _run_build_posesheet() -> void :
	print("POSESHEET: 开始")
	scene_manager.labels_visible = false
	thumb_vp.size = Vector2i(200, 240)
	var far: = Vector3(4000, 0, 4000)
	var names: = FigureLib.POSES.keys()
	print("POSESHEET 顺序: " + ", ".join(PackedStringArray(names)))
	var cols: = 7
	var rows: = ceili(float(names.size()) / cols)
	var sheet: = Image.create(200 * cols, 240 * rows, false, Image.FORMAT_RGB8)
	for i in range(names.size()):
		var fig: = scene_manager.add_figure(far, "standard", String(names[i]))
		var aabb: = scene_manager.get_local_aabb(fig)
		var center: Vector3 = fig.global_transform * aabb.get_center()
		var radius: = maxf(aabb.size.length() * 0.5, 0.6)
		thumb_cam.fov = 30.0
		thumb_cam.global_position = center\
		+ Vector3(0.55, 0.3, 1.0).normalized() * (radius / tan(deg_to_rad(15.0)) * 1.05)
		thumb_cam.look_at(center)
		thumb_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
		await RenderingServer.frame_post_draw
		await get_tree().process_frame
		var img: = thumb_vp.get_texture().get_image()
		img.convert(Image.FORMAT_RGB8)
		sheet.blit_rect(img, Rect2i(0, 0, 200, 240), 
			Vector2i((i % cols) * 200, (i / cols) * 240))
		fig.free()
	sheet.save_png(ProjectSettings.globalize_path("user://poses_sheet.png"))
	print("POSESHEET: 完成 %d 个姿势" % names.size())
	get_tree().quit(0)




func _spawn_demo_content() -> void :
	var b: = scene_manager.add_primitive("box", Vector3(0, 0, 0))
	scene_manager.select(b)
	scene_manager.set_selected_color(Color(0.85, 0.25, 0.25))
	scene_manager.add_primitive("sphere", Vector3(3, 0, 2))
	scene_manager.add_primitive("figure", Vector3(-3, 0, 2))
	scene_manager.add_primitive("ramp", Vector3(2, 0, -3))
	if model_lookup.has("vehicle/sedan"):
		var info: Dictionary = model_lookup["vehicle/sedan"]
		scene_manager.add_model(info.entry, float(info.cat_scale), Vector3(-2, 0, -4))
	_set_mode(true)
	fly_cam.global_position = Vector3(-8, 2, 8)
	fly_cam.look_at(Vector3.ZERO)
	playhead = 0.0
	_add_camera_keyframe()
	fly_cam.global_position = Vector3(9, 8, 9)
	fly_cam.look_at(Vector3.ZERO)
	playhead = 4.0
	_add_camera_keyframe()
	scene_manager.select(b)
	playhead = 0.0
	_add_object_keyframe()
	b.position.x = 6.0
	playhead = 4.0
	_add_object_keyframe()
	_shot()["duration"] = 5.0
	_set_env_preset("dusk")
	labels_burn = true
	_create_shot()
	fly_cam.global_position = Vector3(0, 20, 0.5)
	fly_cam.look_at(Vector3.ZERO)
	playhead = 0.0
	_add_camera_keyframe()
	_switch_shot(0)


func _run_smoke() -> void :
	print("== SMOKE start ==")
	_spawn_demo_content()
	var expect: = 5 if model_lookup.has("vehicle/sedan") else 4
	assert (scene_manager.count_objects() == expect)
	assert (shots.size() == 2)
	assert (_cam_kf().size() == 2)
	assert ((_obj_kf() as Dictionary).size() == 1)

	_apply_camera_preset("orbit180", "环绕 180°")
	assert (_cam_kf().size() == 5)
	_save_project_to("user://smoke_project.json")
	scene_manager.clear_objects()
	shots = [_make_shot("段落1")]
	cur_shot = 0
	env_preset = "day"
	labels_burn = false
	var ok: = _load_project_from("user://smoke_project.json")
	assert (ok)
	await get_tree().process_frame
	await get_tree().process_frame
	assert (scene_manager.count_objects() == expect)
	assert (shots.size() == 2)
	assert (_cam_kf().size() == 5)
	assert ((_obj_kf() as Dictionary).size() == 1)
	assert (env_preset == "dusk")
	assert (labels_burn == true)
	_apply_at(2.0)

	var objs: = scene_manager.list_objects()
	scene_manager.select_many([objs[0], objs[1]])
	var o0: Node3D = objs[0]
	var o1: Node3D = objs[1]
	var grp_center: Vector3 = (o0.global_position + o1.global_position) * 0.5
	var g: = scene_manager.group_selected()
	assert (g != null)

	assert (g.global_position.distance_to(grp_center) < 2.0)
	assert (g.global_position.length() > 0.5)
	var after_group: = scene_manager.count_objects()
	_save_project_to("user://smoke_group.json")
	scene_manager.clear_objects()
	var group_loaded: = _load_project_from("user://smoke_group.json")
	assert (group_loaded)
	await get_tree().process_frame
	await get_tree().process_frame
	assert (scene_manager.count_objects() == after_group)
	var g2: Node3D = null
	for o in scene_manager.list_objects():
		if String(o.get_meta("kind")) == "group":
			g2 = o
	assert (g2 != null)
	scene_manager.select(g2)
	var ungrouped: = scene_manager.ungroup_selected()
	assert (ungrouped)
	await get_tree().process_frame
	assert (scene_manager.count_objects() == after_group + 1)
	print("SMOKE GROUP OK: objects=%d" % scene_manager.count_objects())

	_set_track_mode(true)
	_clear_waypoints()
	fly_cam.global_position = Vector3(-6, 2, 6)
	fly_cam.look_at(Vector3.ZERO)
	_record_waypoint()
	var wp_obj: Node3D = scene_manager.list_objects()[0]
	wp_obj.position += Vector3(3, 0, 0)
	fly_cam.global_position = Vector3(6, 3, 6)
	fly_cam.look_at(Vector3.ZERO)
	_record_waypoint()
	assert (_cam_kf().size() == 2)
	assert ((_obj_kf() as Dictionary).size() == 1)

	fly_cam.global_position = Vector3(-11, 4, 2)
	_update_waypoint(0)
	assert (_wp_stack().size() == 2)
	assert ((_cam_kf()[0].pos as Vector3).distance_to(Vector3(-11, 4, 2)) < 0.001)

	_set_waypoint_time(1, 5.0, null)
	assert (absf(float(_wp_stack()[1].t) - 5.0) < 0.001)
	assert (absf(float(_cam_kf()[1].t) - 5.0) < 0.001)
	_set_waypoint_time(1, 0.0, null)
	assert (float(_wp_stack()[1].t) > float(_wp_stack()[0].t))
	_undo_waypoint()
	assert (_cam_kf().size() == 1)
	assert ((_obj_kf() as Dictionary).is_empty())
	print("SMOKE AUTO-TRACK OK")

	_clear_waypoints()
	fly_cam.global_position = Vector3(1, 1, 1);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(2, 2, 2);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(3, 3, 3);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	var wt0: = float(_wp_stack()[0].t)
	var wt2: = float(_wp_stack()[2].t)
	_move_waypoint(0, 2)
	assert (absf(float(_wp_stack()[0].t) - wt0) < 0.001)
	assert (absf(float(_wp_stack()[2].t) - wt2) < 0.001)
	assert ((_cam_kf()[2].pos as Vector3).distance_to(Vector3(1, 1, 1)) < 0.01)
	assert ((_cam_kf()[0].pos as Vector3).distance_to(Vector3(2, 2, 2)) < 0.01)
	print("SMOKE WP-REORDER OK")
	_clear_waypoints()

	fly_cam.global_position = Vector3(1, 1, 1);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(5, 5, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(9, 9, 9);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	_delete_waypoint(1)
	assert (_wp_stack().size() == 2)
	assert (_cam_kf().size() == 2)
	assert ((_cam_kf()[0].pos as Vector3).distance_to(Vector3(1, 1, 1)) < 0.1)
	assert ((_cam_kf()[1].pos as Vector3).distance_to(Vector3(9, 9, 9)) < 0.1)
	print("SMOKE WP-DELETE OK")
	_clear_waypoints()

	cur_shot = 0
	_clear_waypoints();scene_manager.clear_objects()
	var pbox: = scene_manager.add_primitive("box", Vector3(0, 0, 0))
	fly_cam.global_position = Vector3(5, 2, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	pbox.position = Vector3(2, 0, 0)
	fly_cam.global_position = Vector3(6, 3, 6);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	var wp_n: = _wp_stack().size()
	var wp_t1: = float(_wp_stack()[1].t)
	_save_project_to("user://smoke_wp.json")
	scene_manager.clear_objects()
	assert (_load_project_from("user://smoke_wp.json"))
	await get_tree().process_frame
	assert (_wp_stack().size() == wp_n)
	assert (absf(float(_wp_stack()[1].t) - wp_t1) < 0.01)
	assert ((_wp_stack()[0].cam_pos as Vector3).distance_to(Vector3(5, 2, 5)) < 0.2)
	assert ((_wp_stack()[1].objs as Dictionary).size() >= 1)
	print("SMOKE WP-PERSIST OK (读档得到 %d 个机位点)" % _wp_stack().size())
	_clear_waypoints()

	scene_manager.clear_objects()
	var wf: = scene_manager.add_figure(Vector3(0, 0, 0))
	var wfn: = String(wf.name)
	fly_cam.global_position = Vector3(5, 3, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(6, 3, 6);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(7, 3, 7);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	assert ((_obj_kf() as Dictionary).is_empty())

	_apply_at(float(_wp_stack()[1].t));wf.global_position = Vector3(0, 5, 0);_update_waypoint(1)
	_apply_at(float(_wp_stack()[2].t));wf.global_position = Vector3(3, 1, 0);_update_waypoint(2)
	assert ((_obj_kf() as Dictionary).has(wfn))
	_apply_at(float(_wp_stack()[0].t));assert (wf.position.distance_to(Vector3(0, 0, 0)) < 0.2)
	_apply_at(float(_wp_stack()[1].t));assert (wf.position.distance_to(Vector3(0, 5, 0)) < 0.2)
	_apply_at(float(_wp_stack()[2].t));assert (wf.position.distance_to(Vector3(3, 1, 0)) < 0.2)
	print("SMOKE WP-INDEP-KF OK")

	_clear_waypoints();scene_manager.clear_objects()
	var pf: = scene_manager.add_figure(Vector3(0, 0, 0))
	scene_manager.set_figure_pose(pf, "站立")
	fly_cam.global_position = Vector3(5, 3, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	scene_manager.set_figure_pose(pf, "坐姿")
	fly_cam.global_position = Vector3(6, 3, 6);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	var t0: = float(_wp_stack()[0].t)
	var t1: = float(_wp_stack()[1].t)
	var hip: = pf.find_child("J_hip_l", true, false) as Node3D
	_apply_at(t0); var a0: = hip.rotation_degrees.x
	_apply_at(t1); var a1: = hip.rotation_degrees.x
	_apply_at((t0 + t1) * 0.5); var amid: = hip.rotation_degrees.x
	assert (absf(a0) < 8.0)
	assert (a1 > 70.0)
	assert (amid > a0 + 15.0 and amid < a1 - 15.0)
	print("SMOKE WP-POSE-KF OK (髋角 站立=%.0f 中点=%.0f 坐姿=%.0f)" % [a0, amid, a1])

	_clear_waypoints();scene_manager.clear_objects()
	var uf: = scene_manager.add_figure(Vector3(0, 0, 0))
	var uhip: = uf.find_child("J_hip_l", true, false) as Node3D
	scene_manager.set_figure_pose(uf, "坐姿")
	fly_cam.global_position = Vector3(5, 3, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	scene_manager.set_figure_pose(uf, "站立")
	fly_cam.global_position = Vector3(6, 3, 6);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	assert (absf(uhip.rotation_degrees.x) < 8.0)
	_undo_waypoint()
	assert (uhip.rotation_degrees.x > 70.0)
	print("SMOKE WP-UNDO-POSE OK (撤点后髋角=%.0f 回坐姿)" % uhip.rotation_degrees.x)
	_clear_waypoints();scene_manager.clear_objects()

	_clear_waypoints()
	fly_cam.global_position = Vector3(1, 1, 1);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(8, 2, 3);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(4, 6, 9);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	_set_waypoint_time(1, 1.2, null)
	assert (absf(float(_wp_stack()[1].t) - 1.2) < 0.01)
	for wi in range(3):
		_apply_at(float(_wp_stack()[wi].t))
		assert (fly_cam.global_position.distance_to(_cam_kf()[wi].pos as Vector3) < 0.1)
		assert (absf(float(_wp_stack()[wi].t) - float(_cam_kf()[wi].t)) < 0.001)
	print("SMOKE WP-RETIME-JUMP OK")

	_clear_waypoints()
	fly_cam.global_position = Vector3(1, 1, 1);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(2, 2, 2);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(3, 3, 3);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	var mid_t: = float(_wp_stack()[1].t)
	_set_total_duration(13.0)
	assert (absf(_duration() - 13.0) < 0.01)
	assert (absf(float(_wp_stack()[-1].t) - 13.0) < 0.01)
	assert (absf(float(_wp_stack()[1].t) - mid_t) < 0.01)
	print("SMOKE WP-TOTAL-DUR OK (总时长=%.1f 中点不变=%.2f)" % [_duration(), float(_wp_stack()[1].t)])
	_clear_waypoints()

	_clear_waypoints()
	fly_cam.global_position = Vector3(0, 1, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(0, 1, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(6, 1, 0);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	var mid: = _sample_keys(_cam_kf(), 0.75)
	assert ((mid.pos as Vector3).distance_to(Vector3(0, 1, 5)) < 0.01)

	_clear_waypoints()
	fly_cam.global_position = Vector3(0, 3, 6);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(3, 0.1, 3);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(6, 3, 0);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	var pend2: = float(_cam_kf()[-1].t)
	var min_y: = 999.0
	for si in range(41):
		var yy: = (_sample_keys(_cam_kf(), pend2 * float(si) / 40.0).pos as Vector3).y
		min_y = minf(min_y, yy)
	assert (min_y > 0.1 - 0.001)
	print("SMOKE NO-OVERSHOOT OK (原地不飘;贴地俯冲最低 Y=%.3f≥0.1)" % min_y)
	_clear_waypoints()
	fly_cam.global_position = Vector3(0, 1, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(0, 1, 5);fly_cam.look_at(Vector3.ZERO);_record_waypoint()
	fly_cam.global_position = Vector3(6, 1, 0);fly_cam.look_at(Vector3.ZERO);_record_waypoint()

	var _sv_shots: = shots.duplicate()
	var _sv_cur: = cur_shot
	shots = [shots[cur_shot]];cur_shot = 0
	_shot()["handheld"] = 0.0
	var pend: = _preview_end()
	playhead = pend - 0.02
	playing = true;playing_all = true
	for _i in range(10):
		_process(0.1)
		if not playing:
			break
	assert ( not playing)
	assert (playhead > pend - 0.001)
	assert ((fly_cam.global_position as Vector3).distance_to(Vector3(0, 1, 5)) > 3.0)
	print("SMOKE PLAY-END-AT-LAST OK (末帧 playhead=%.2f 不回开头)" % playhead)
	shots = _sv_shots;cur_shot = _sv_cur
	_clear_waypoints()
	scene_manager.clear_objects()

	var cbox: = scene_manager.add_primitive("box", Vector3(0, 0, 0))
	var cba: = _world_aabb_of(cbox)
	var box_top: = cba.position.y + cba.size.y
	var cfig: = scene_manager.add_figure(Vector3(6, 0, 6))
	assert (absf(_support_height_at(0, 0, cfig) - box_top) < 0.02)
	assert (absf(_support_height_at(6, 6, cfig) - 0.0) < 0.02)
	var foff: = _world_aabb_of(cfig).position.y - cfig.global_position.y
	cfig.global_position = Vector3(0, box_top - foff, 0)
	assert (absf(_world_aabb_of(cfig).position.y - box_top) < 0.03)
	print("SMOKE SURFACE-SNAP OK (箱顶=%.2f 脚底=%.2f)" % [
		box_top, _world_aabb_of(cfig).position.y])
	scene_manager.clear_objects()

	fly_cam.set_view_preset("two_point")
	fly_cam.look_angle = 0.4
	fly_cam._refresh_projection()
	var test_pt: = Vector2(700, 300)
	var tp_ray: = fly_cam.mouse_ray(test_pt)
	var tp_world: Vector3 = tp_ray[0] + (tp_ray[1] as Vector3) * 8.0
	var tp_back = fly_cam.world_to_screen(tp_world)
	assert (tp_back != null)
	assert ((tp_back as Vector2).distance_to(test_pt) < 2.0)
	fly_cam.set_view_preset("persp")
	print("SMOKE TWO-POINT RAY OK (误差 %.2fpx)" % (tp_back as Vector2).distance_to(test_pt))

	fly_cam.set_view_preset("persp")
	fly_cam.global_position = Vector3(0, 0.4, 5)
	fly_cam.look_at(Vector3(0, -3, 0))
	fly_cam._on_wheel(1)
	assert (fly_cam.global_position.y >= FlyCamera.FLOOR_Y - 0.001)
	print("SMOKE FLOOR OK (y=%.3f)" % fly_cam.global_position.y)
	_set_track_mode(false)
	_clear_waypoints()

	var fig: = scene_manager.add_figure(Vector3(6, 0, 6), "female", "坐姿")
	assert (String(fig.get_meta("figure_pose")) == "坐姿")

	fig.global_position = Vector3(6, 3, 6)
	var air_bottom: = fig.global_position.y + (fig.get_meta("local_aabb") as AABB).position.y * fig.scale.y
	scene_manager.set_figure_pose(fig, "站立")
	var new_bottom: = fig.global_position.y + (fig.get_meta("local_aabb") as AABB).position.y * fig.scale.y
	assert (absf(new_bottom - air_bottom) < 0.01)
	assert (fig.global_position.y > 2.0)
	scene_manager.set_figure_pose(fig, "坐姿")
	_save_project_to("user://smoke_fig.json")
	scene_manager.clear_objects()
	var fig_loaded: = _load_project_from("user://smoke_fig.json")
	assert (fig_loaded)
	await get_tree().process_frame
	await get_tree().process_frame
	var found_fig: = false
	for o in scene_manager.list_objects():
		if String(o.get_meta("kind")) == "figure"\
		and String(o.get_meta("figure_type", "")) == "female"\
		and String(o.get_meta("figure_pose", "")) == "坐姿":
			found_fig = true
	assert (found_fig)
	print("SMOKE FIGURE OK")


	var sb: = scene_manager.add_primitive("box", Vector3(0, 0, 0))
	scene_manager.select(sb)
	fly_cam.set_view_preset("persp")
	fly_cam.global_position = Vector3(-9, 3, 9)
	fly_cam.look_at(Vector3.ZERO)
	_update_gizmo()
	var handle_ok: = scale_handle != null and scale_handle.visible
	var pivot_scr = fly_cam.world_to_screen(sb.global_position)
	var handle_scr = fly_cam.world_to_screen(scale_handle.global_position)
	assert (pivot_scr != null and handle_scr != null)
	var y0: = sb.global_position.y
	_begin_scale(handle_scr)

	var dirv: = ((handle_scr as Vector2) - (pivot_scr as Vector2))
	dirv = dirv.normalized() if dirv.length() > 0.001 else Vector2.RIGHT
	var far_pt: Vector2 = (pivot_scr as Vector2) + dirv * (_scale_d0 * 2.0)
	_update_scale(far_pt)
	var grew: = sb.scale.x
	assert (grew > 1.6 and grew < 2.4)
	assert (sb.global_position.y >= y0 - 0.001)
	_scaling = false

	_dragging = true
	_drag_plane_y = sb.global_position.y
	_drag_pos = sb.global_position
	var before: = sb.global_position
	_update_drag(Vector2(40, 0))
	var moved: = before.distance_to(sb.global_position)
	assert (moved > 0.001 and moved < 50.0)
	_dragging = false

	scene_manager.select(sb)
	sb.rotation = Vector3.ZERO
	_rotate_selected(90.0)
	assert (absf(rad_to_deg(sb.rotation.y) - 90.0) < 0.01)
	sb.rotation = Vector3.ZERO
	assert (sb.rotation.is_equal_approx(Vector3.ZERO))

	_update_gizmo()
	var c: = sb.global_position
	var rr: = TranslateGizmo.RING_R * gizmo.scale.x
	var ring_o1: = c + Vector3(rr, 3.0, 0.0)
	var ring_dn: = Vector3(0.0, -1.0, 0.0)
	assert (gizmo.hit_test_ring(ring_o1, ring_dn) == "y")
	_begin_ring_rotate("y", ring_o1, ring_dn)
	var a2: = _ring_angle(c + Vector3(0.0, 3.0, rr), ring_dn)
	var nb: = Basis(_rot_axis, a2 - _rot_start_angle) * _rot_start_basis
	sb.global_transform = Transform3D(nb, _rot_origin)
	assert (absf(absf(rad_to_deg(sb.rotation.y)) - 90.0) < 2.0)
	_rot_drag = ""
	scene_manager.select(null)
	print("SMOKE SCALE/DRAG/ROT OK (放大=%.2f× 拖动=%.2fm 环命中=y)" % [grew, moved])


	var tshot: = _make_shot("时长测试")
	tshot["cam_kf"] = [
		{"t": 0.0, "pos": Vector3.ZERO, "rot": Quaternion.IDENTITY, "fov": 60.0, "shift": 0.0}, 
		{"t": 4.0, "pos": Vector3(2, 0, 0), "rot": Quaternion.IDENTITY, "fov": 60.0, "shift": 0.0}]
	shots.append(tshot)
	_switch_shot(shots.size() - 1)
	assert (absf(_last_key_time() - 4.0) < 0.001)
	_set_shot_duration_scaled(8.0)
	assert (absf(_last_key_time() - 8.0) < 0.01)
	assert (absf(_duration() - 8.0) < 0.01)

	var ho1: = _handheld_offset(2.5, 0.8)
	var ho2: = _handheld_offset(2.5, 0.8)
	var ho3: = _handheld_offset(2.6, 0.8)
	assert ((ho1.pos as Vector3).is_equal_approx(ho2.pos as Vector3))
	assert ( not (ho1.pos as Vector3).is_equal_approx(ho3.pos as Vector3))
	assert ((ho1.pos as Vector3).length() < 0.12)
	assert ((ho1.rot as Vector3).length() < 0.05)

	var _sv_playing: = playing
	playing = true
	_shot()["handheld"] = 0.0
	_apply_at(3.0)
	var cam_plain: = fly_cam.global_position
	_shot()["handheld"] = 0.8
	_apply_at(3.0)
	var cam_shaken: = fly_cam.global_position
	assert (cam_plain.distance_to(cam_shaken) > 0.001)

	playing = false
	_apply_at(3.0)
	assert (fly_cam.global_position.distance_to(cam_plain) < 0.001)
	_shot()["handheld"] = 0.0
	playing = _sv_playing
	print("SMOKE DURATION/HANDHELD OK (拉伸末帧=%.1fs 抖动位移=%.3fm)" % [
		_last_key_time(), cam_plain.distance_to(cam_shaken)])


	var fc: = _compute_frame_crop()
	var fcrop: Rect2i = fc.crop
	assert (fcrop.size.x > 0 and fcrop.size.y > 0)
	assert (fcrop.position.x >= 0 and fcrop.position.y >= 0)
	assert (fcrop.position.x + fcrop.size.x <= int(fc.rw))
	assert (fcrop.position.y + fcrop.size.y <= int(fc.rh))
	print("SMOKE CROP OK (裁剪 %dx%d @ 渲染 %dx%d)" % [
		fcrop.size.x, fcrop.size.y, int(fc.rw), int(fc.rh)])


	_undo_stack.clear()
	var n0: = scene_manager.count_objects()
	_push_undo()
	scene_manager.add_primitive("box", Vector3(5, 0, 5))
	assert (scene_manager.count_objects() == n0 + 1)
	_undo()
	await get_tree().process_frame
	assert (scene_manager.count_objects() == n0)
	assert (_undo_stack.is_empty())
	print("SMOKE UNDO OK (撤销后 objects=%d)" % scene_manager.count_objects())


	while shots.size() < 3:
		shots.append(_make_shot("段落%d" % (shots.size() + 1)))
	shots[0]["name"] = "A"
	shots[1]["name"] = "B"
	shots[2]["name"] = "C"
	cur_shot = 1
	_move_shot(0, 2)
	assert (String(shots[2].name) == "A")
	assert (String(shots[1].name) == "C")
	assert (String(shots[cur_shot].name) == "B")
	print("SMOKE SHOT-REORDER OK (顺序=%s)" % str(shots.map( func(s): return String(s.name))))


	_new_project()
	assert (scene_manager.count_objects() == 0)
	assert (shots.size() == 1)
	assert (project_path == "")
	print("SMOKE NEW-PROJECT OK")

	var reload_ok: = _load_project_from("user://smoke_project.json")
	assert (reload_ok)
	await get_tree().process_frame
	print("SMOKE OK: objects=%d shots=%d camkeys=%d objtracks=%d" % [
		scene_manager.count_objects(), shots.size(), 
		_cam_kf().size(), (_obj_kf() as Dictionary).size()])
	if OS.get_cmdline_user_args().has("--previz-smoke-export"):
		var out: = ProjectSettings.globalize_path("user://smoke_out.mp4")
		_start_export(out)
		var result: Array = await export_manager.finished
		if result[0]:
			print("SMOKE EXPORT OK: " + String(result[1]))
			get_tree().quit(0)
		else:
			print("SMOKE EXPORT FAIL: " + String(result[1]))
			get_tree().quit(1)
		return
	get_tree().quit(0)


func _run_uishot() -> void :
	_spawn_demo_content()

	_set_track_mode(true)
	_clear_waypoints()
	fly_cam.global_position = Vector3(-9, 2, 9)
	fly_cam.look_at(Vector3.ZERO)
	_record_waypoint()
	fly_cam.global_position = Vector3(0, 5, 12)
	fly_cam.look_at(Vector3.ZERO)
	_record_waypoint()
	fly_cam.global_position = Vector3(9, 7, 6)
	fly_cam.look_at(Vector3.ZERO)
	_record_waypoint()
	await _save_uishot("uishot.png")


func _run_uishot_layout() -> void :
	_spawn_demo_content()
	_set_mode(false)
	if OS.get_cmdline_user_args().has("--previz-blur"):
		_blur_test = true

	var pick_obj: Node3D = scene_manager.list_objects()[0]
	for o in scene_manager.list_objects():
		if String(o.get_meta("kind")) == "figure":
			pick_obj = o
	scene_manager.select(pick_obj)
	if OS.get_cmdline_user_args().has("--previz-twopoint"):
		fly_cam.global_position = Vector3(4, 0.8, 9)
		fly_cam.look_at(Vector3(2, 0.8, 0))
		_set_view("two_point")
		fly_cam.look_angle = 0.55
		fly_cam._refresh_projection()
	if OS.get_cmdline_user_args().has("--previz-dusk"):
		_set_env_preset("dusk")
	elif OS.get_cmdline_user_args().has("--previz-night"):
		_set_env_preset("night")
	if OS.get_cmdline_user_args().has("--previz-assets"):
		right_tab_tools.visible = false
		right_tab_assets.visible = true
	await _save_uishot("uishot_layout.png")


func _run_uishot_dialog() -> void :
	_spawn_demo_content()
	crowd_dialog.popup_centered()
	await _save_uishot("uishot_dialog.png")



func _run_still_test() -> void :
	_spawn_demo_content()
	for i in range(20):
		await get_tree().process_frame
	var fc: = _compute_frame_crop()
	await _export_still(ProjectSettings.globalize_path("user://still_test.png"))
	var img: = Image.load_from_file(ProjectSettings.globalize_path("user://still_test.png"))
	if img:
		print("STILL-TEST: png=%dx%d 期望裁剪=%dx%d" % [
			img.get_width(), img.get_height(), 
			int((fc.crop as Rect2i).size.x), int((fc.crop as Rect2i).size.y)])
	else:
		print("STILL-TEST: 读图失败")
	get_tree().quit(0)



func _run_uishot_empty() -> void :
	_spawn_demo_content()
	_set_track_mode(true)
	_clear_waypoints()
	await _save_uishot("uishot_empty.png")



func _run_uishot_login() -> void :
	_build_login_gate()
	_login_account.text = "previz_test"
	_show_login_form()
	await _save_uishot("uishot_login.png")



func _run_ffmpeg_test() -> void :
	var em: = ExportManager.new()
	add_child(em)

	var ff: = em._extract_bundled_ffmpeg()
	print("FFMPEG-TEST path=%s exists=%s" % [ff, str(FileAccess.file_exists(ff))])
	if not ff.is_empty():
		var out: Array = []
		var code: = OS.execute(ff, ["-version"], out, true)
		var ver: = "(no output)"
		if not out.is_empty():
			ver = str(out[0]).substr(0, 90)
		print("FFMPEG-TEST exec_code=%d ver=%s" % [code, ver])
	get_tree().quit(0)



func _run_patch_test() -> void :
	var up: = Updater.new()
	add_child(up)
	var hp: = up._extract_hpatchz()
	print("PATCH-TEST hpatchz=%s exists=%s" % [hp, str(FileAccess.file_exists(hp))])
	if not hp.is_empty():
		var out: Array = []
		OS.execute(hp, [], out, true)
		var ver: = "(no output)"
		if not out.is_empty():
			ver = str(out[0]).substr(0, 60)
		print("PATCH-TEST ver=%s" % ver)
	get_tree().quit(0)


func _save_uishot(fname: String) -> void :
	for i in range(20):
		await get_tree().process_frame
	var img: = get_viewport().get_texture().get_image()
	img.save_png(ProjectSettings.globalize_path("user://" + fname))
	print("UISHOT saved: " + fname)
	get_tree().quit(0)
