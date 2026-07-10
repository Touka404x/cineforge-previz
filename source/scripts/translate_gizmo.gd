class_name TranslateGizmo
extends Node3D





const LEN: = 1.0
const RING_R: = 1.32
const RING_HALF: = 0.014
const RING_SEG: = 72
const AXES: = {
	"x": [Vector3.RIGHT, Color("e5484d")], 
	"y": [Vector3.UP, Color("46a758")], 
	"z": [Vector3.BACK, Color("3b82f6")], 
}

const RING_NORMAL: = {
	"x": Vector3.RIGHT, 
	"y": Vector3.UP, 
	"z": Vector3.BACK, 
}


func _ready() -> void :
	for key in AXES:
		var dir_col: Array = AXES[key]
		add_child(_make_arrow(String(key), dir_col[1]))
	for key in RING_NORMAL:
		add_child(_make_ring(String(key), (AXES[key][1] as Color)))
	visible = false


func _make_ring(key: String, col: Color) -> MeshInstance3D:


	var n: Vector3 = RING_NORMAL[key]
	var u: = n.cross(Vector3.UP)
	if u.length() < 0.01:
		u = n.cross(Vector3.RIGHT)
	u = u.normalized()
	var v: = n.cross(u).normalized()
	var im: = ImmediateMesh.new()
	im.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(RING_SEG + 1):
		var ang: = TAU * float(i) / float(RING_SEG)
		var d: = u * cos(ang) + v * sin(ang)
		im.surface_add_vertex(d * (RING_R - RING_HALF))
		im.surface_add_vertex(d * (RING_R + RING_HALF))
	im.surface_end()
	var mi: = MeshInstance3D.new()
	mi.name = "Ring_" + key
	mi.mesh = im
	var mat: = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(col.r, col.g, col.b, 0.5)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.no_depth_test = true
	mat.render_priority = 9
	mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mi.layers = 2
	return mi


func _make_arrow(key: String, col: Color) -> Node3D:
	var root: = Node3D.new()
	root.name = "Axis_" + key
	var mat: = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(col.r, col.g, col.b, 0.6)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.no_depth_test = true
	mat.render_priority = 10

	var shaft: = MeshInstance3D.new()
	var cyl: = CylinderMesh.new()
	cyl.top_radius = 0.028
	cyl.bottom_radius = 0.028
	cyl.height = LEN
	shaft.mesh = cyl
	shaft.material_override = mat
	shaft.position = Vector3(0, LEN * 0.5, 0)
	shaft.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	shaft.layers = 2
	root.add_child(shaft)

	var head: = MeshInstance3D.new()
	var cone: = CylinderMesh.new()
	cone.top_radius = 0.0
	cone.bottom_radius = 0.085
	cone.height = 0.24
	head.mesh = cone
	head.material_override = mat
	head.position = Vector3(0, LEN + 0.11, 0)
	head.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	head.layers = 2
	root.add_child(head)


	if key == "x":
		root.rotation_degrees = Vector3(0, 0, -90)
	elif key == "z":
		root.rotation_degrees = Vector3(90, 0, 0)
	return root



static func closest_on_axis(axis_origin: Vector3, axis_dir: Vector3, 
		ray_origin: Vector3, ray_dir: Vector3) -> Vector2:
	var w0: = axis_origin - ray_origin
	var b: = axis_dir.dot(ray_dir)
	var d: = axis_dir.dot(w0)
	var e: = ray_dir.dot(w0)
	var denom: = 1.0 - b * b
	if absf(denom) < 1e-05:
		return Vector2(0.0, 1000000000.0)
	var t: = (b * e - d) / denom
	var s: = (e - b * d) / denom
	var p_axis: = axis_origin + axis_dir * t
	var p_ray: = ray_origin + ray_dir * maxf(s, 0.0)
	return Vector2(t, p_axis.distance_to(p_ray))



func hit_test(ray_origin: Vector3, ray_dir: Vector3) -> String:
	if not visible:
		return ""
	var handle_len: = LEN * scale.x * 1.25
	var threshold: = 0.14 * scale.x
	var best: = ""
	var best_dist: = threshold
	for key in AXES:
		var axis: Vector3 = (AXES[key][0] as Vector3)
		var r: = closest_on_axis(global_position, axis, ray_origin, ray_dir)
		if r.x >= -0.05 and r.x <= handle_len and r.y < best_dist:
			best_dist = r.y
			best = String(key)
	return best




func hit_test_ring(ray_origin: Vector3, ray_dir: Vector3) -> String:
	if not visible:
		return ""
	var r_world: = RING_R * scale.x
	var threshold: = 0.16 * scale.x
	var best: = ""
	var best_dist: = threshold
	for key in RING_NORMAL:
		var n: Vector3 = RING_NORMAL[key]
		var denom: = n.dot(ray_dir)
		if absf(denom) < 1e-06:
			continue
		var t: = (global_position - ray_origin).dot(n) / denom
		if t < 0.0:
			continue
		var hit: = ray_origin + ray_dir * t
		var d: = absf(hit.distance_to(global_position) - r_world)
		if d < best_dist:
			best_dist = d
			best = String(key)
	return best
