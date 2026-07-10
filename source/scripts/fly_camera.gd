class_name FlyCamera
extends Camera3D






signal took_control

const NEAR: = 0.05
const FAR: = 4000.0
const LOOK_LIMIT: = 0.56
const FLOOR_Y: = 0.05

var move_speed: = 10.0
var look_sensitivity: = 0.0025
var looking: = false
var input_enabled: = true


var two_point: = false
var look_angle: = 0.0
var fov_deg: = 75.0

var _persp_saved: = false
var _persp_transform: Transform3D


func _unhandled_input(event: InputEvent) -> void :
	if not input_enabled:
		return
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				looking = event.pressed
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if looking\
				else Input.MOUSE_MODE_VISIBLE
				if looking:
					took_control.emit()
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					_on_wheel(1)
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					_on_wheel(-1)
	elif event is InputEventMouseMotion and looking:
		rotation.y -= event.relative.x * look_sensitivity
		if two_point and projection != PROJECTION_ORTHOGONAL:
			look_angle = clampf(look_angle - event.relative.y * look_sensitivity, 
				- LOOK_LIMIT, LOOK_LIMIT)
			_refresh_projection()
		else:
			rotation.x = clampf(rotation.x - event.relative.y * look_sensitivity, -1.55, 1.55)


func _on_wheel(dir: int) -> void :
	if looking:

		move_speed = clampf(move_speed * (1.15 if dir > 0 else 1.0 / 1.15), 0.5, 100.0)
		return
	took_control.emit()
	if projection == PROJECTION_ORTHOGONAL:
		size = clampf(size * (0.88 if dir > 0 else 1.136), 1.0, 300.0)
	else:
		translate_object_local(Vector3(0, 0, - dir * move_speed * 0.35))
		if global_position.y < FLOOR_Y:
			global_position.y = FLOOR_Y


func _process(delta: float) -> void :
	if not input_enabled:
		return


	var foc: = get_viewport().gui_get_focus_owner()
	if foc is LineEdit or foc is TextEdit:
		return
	var dir: = Vector3.ZERO
	if projection == PROJECTION_ORTHOGONAL:

		if Input.is_key_pressed(KEY_W):
			dir += basis.y
		if Input.is_key_pressed(KEY_S):
			dir -= basis.y
		if Input.is_key_pressed(KEY_A):
			dir -= basis.x
		if Input.is_key_pressed(KEY_D):
			dir += basis.x
	else:
		if Input.is_key_pressed(KEY_W):
			dir -= basis.z
		if Input.is_key_pressed(KEY_S):
			dir += basis.z
		if Input.is_key_pressed(KEY_A):
			dir -= basis.x
		if Input.is_key_pressed(KEY_D):
			dir += basis.x
		if Input.is_key_pressed(KEY_Q):
			dir += Vector3.UP
		if Input.is_key_pressed(KEY_E):
			dir -= Vector3.UP
	if dir != Vector3.ZERO:
		took_control.emit()
		var mult: = 3.0 if Input.is_key_pressed(KEY_SHIFT) else 1.0
		global_position += dir.normalized() * move_speed * mult * delta
		if global_position.y < FLOOR_Y:
			global_position.y = FLOOR_Y



func set_view_preset(preset: String) -> void :
	match preset:
		"persp", "two_point":
			if projection == PROJECTION_ORTHOGONAL and _persp_saved:
				global_transform = _persp_transform
			_set_two_point(preset == "two_point")
			return
	if projection != PROJECTION_ORTHOGONAL:
		_persp_transform = global_transform
		_persp_saved = true
	projection = PROJECTION_ORTHOGONAL
	size = 26.0
	match preset:
		"top":
			global_position = Vector3(global_position.x, 60.0, global_position.z)
			rotation_degrees = Vector3(-90, 0, 0)
		"front":
			global_position = Vector3(global_position.x, 4.0, 60.0)
			rotation_degrees = Vector3(0, 0, 0)
		"right":
			global_position = Vector3(60.0, 4.0, global_position.z)
			rotation_degrees = Vector3(0, 90, 0)



func _set_two_point(on: bool) -> void :
	if on and not two_point:
		look_angle = clampf(rotation.x, - LOOK_LIMIT, LOOK_LIMIT)
		rotation.x = 0.0
	elif not on and two_point:
		rotation.x = look_angle
		look_angle = 0.0
	two_point = on
	_refresh_projection()



func mouse_ray(mpos: Vector2) -> Array:
	if two_point and projection == PROJECTION_FRUSTUM:
		var vp: = get_viewport().get_visible_rect().size
		var aspect: = vp.x / vp.y
		var near_h: = 2.0 * NEAR * tan(deg_to_rad(fov_deg) * 0.5)
		var near_w: = near_h * aspect
		var ndc_x: = (mpos.x / vp.x) * 2.0 - 1.0
		var ndc_y: = 1.0 - (mpos.y / vp.y) * 2.0

		var p_local: = Vector3(
			ndc_x * near_w * 0.5, 
			ndc_y * near_h * 0.5 + NEAR * tan(look_angle), 
			- NEAR)
		return [global_position, (global_transform.basis * p_local).normalized()]
	return [project_ray_origin(mpos), project_ray_normal(mpos)]



func world_to_screen(wp: Vector3) -> Variant:
	if two_point and projection == PROJECTION_FRUSTUM:
		var p_local: = global_transform.affine_inverse() * wp
		if p_local.z > - NEAR:
			return null
		var vp: = get_viewport().get_visible_rect().size
		var aspect: = vp.x / vp.y
		var near_h: = 2.0 * NEAR * tan(deg_to_rad(fov_deg) * 0.5)
		var near_w: = near_h * aspect
		var px: = p_local.x * NEAR / - p_local.z
		var py: = p_local.y * NEAR / - p_local.z - NEAR * tan(look_angle)
		var ndc_x: = px / (near_w * 0.5)
		var ndc_y: = py / (near_h * 0.5)
		return Vector2((ndc_x + 1.0) * 0.5 * vp.x, (1.0 - ndc_y) * 0.5 * vp.y)
	if is_position_behind(wp):
		return null
	return unproject_position(wp)


func set_fov_deg(v: float) -> void :
	fov_deg = v
	_refresh_projection()



func apply_animated_pose(tf: Transform3D, fov_v: float, shift: float) -> void :
	global_transform = tf
	fov_deg = fov_v
	two_point = absf(shift) > 0.0001
	look_angle = shift if two_point else 0.0
	_refresh_projection()


func _refresh_projection() -> void :
	if projection == PROJECTION_ORTHOGONAL:
		return
	if two_point:
		var near_h: = 2.0 * NEAR * tan(deg_to_rad(fov_deg) * 0.5)
		set_frustum(near_h, Vector2(0.0, NEAR * tan(look_angle)), NEAR, FAR)
	else:
		set_perspective(fov_deg, NEAR, FAR)
