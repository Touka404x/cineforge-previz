class_name SceneManager
extends Node3D





signal selection_changed(obj: Node3D)
signal objects_changed

const KINDS: = {
	"box": "方盒", 
	"sphere": "球体", 
	"cylinder": "圆柱", 
	"panel": "薄板", 
	"ramp": "斜坡", 
	"figure": "人形", 
}

const LABEL_PIXEL_SIZE: = 0.0035

var selected: Node3D = null
var selected_list: Array = []
var labels_visible: = true
var _counters: Dictionary = {}
var _label_font: SystemFont = null




func _ensure_label_font() -> Font:
	if _label_font == null:
		_label_font = SystemFont.new()
		_label_font.font_names = PackedStringArray(
			["Microsoft YaHei UI", "Microsoft YaHei", "SimHei"])
	return _label_font


func _attach_label(obj: Node3D, aabb: AABB) -> void :
	var lb: = Label3D.new()
	lb.name = "_Label"
	lb.text = String(obj.name)
	lb.font = _ensure_label_font()
	lb.font_size = 48
	lb.outline_size = 14
	lb.outline_modulate = Color(0, 0, 0, 0.85)
	lb.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lb.fixed_size = false
	lb.pixel_size = LABEL_PIXEL_SIZE
	lb.no_depth_test = true
	var invy: = 1.0 / maxf(obj.scale.y, 0.001)
	lb.scale = _label_inv_scale(obj)
	var center: = aabb.get_center()
	lb.position = Vector3(center.x, aabb.position.y + aabb.size.y + 0.35 * invy, center.z)
	lb.visible = labels_visible
	obj.add_child(lb)



static func _label_inv_scale(obj: Node3D) -> Vector3:
	return Vector3(
		1.0 / maxf(obj.scale.x, 0.001), 
		1.0 / maxf(obj.scale.y, 0.001), 
		1.0 / maxf(obj.scale.z, 0.001))



func refresh_labels() -> void :
	for obj in list_objects():
		var lb: = obj.get_node_or_null("_Label") as Label3D
		if lb:
			lb.text = String(obj.name)
			lb.visible = labels_visible
			lb.pixel_size = LABEL_PIXEL_SIZE
			lb.scale = _label_inv_scale(obj)


func set_labels_visible(v: bool) -> void :
	labels_visible = v
	refresh_labels()





func add_figure(at: Vector3, body_type: = "standard", pose: = "站立") -> Node3D:
	var root: = Node3D.new()
	root.set_meta("kind", "figure")
	root.set_meta("figure_type", body_type)
	root.set_meta("figure_pose", pose)
	var cn: = String(FigureLib.BODY_TYPES.get(body_type, 
		FigureLib.BODY_TYPES.standard).cn)
	_counters[cn] = int(_counters.get(cn, 0)) + 1
	root.name = "%s%d" % [cn, _counters[cn]]
	FigureLib.build(root, body_type)
	add_child(root)
	FigureLib.apply_pose(root, pose)
	var aabb: = combined_aabb(root)
	root.set_meta("local_aabb", aabb)
	root.global_position = Vector3(at.x, - aabb.position.y, at.z)
	_attach_label(root, aabb)

	set_color_on(root, Color.from_hsv(randf(), 0.55, 0.82))
	objects_changed.emit()
	return root



func set_figure_pose(obj: Node3D, pose: String) -> void :
	if String(obj.get_meta("kind", "")) != "figure":
		return
	var keep: = obj.global_position

	var old_aabb: AABB = obj.get_meta("local_aabb", combined_aabb(obj))
	var bottom_world: = keep.y + old_aabb.position.y * obj.scale.y
	FigureLib.apply_pose(obj, pose)
	obj.set_meta("figure_pose", pose)
	var aabb: = combined_aabb(obj)
	obj.set_meta("local_aabb", aabb)
	var lb: = obj.get_node_or_null("_Label")
	if lb:
		lb.free()
	_attach_label(obj, aabb)
	refresh_labels()
	obj.global_position = Vector3(keep.x, bottom_world - aabb.position.y * obj.scale.y, keep.z)
	if selected_list.has(obj):
		_set_overlay(obj, true)


func add_primitive(kind: String, at: Vector3) -> Node3D:
	if kind == "figure":
		return add_figure(at)
	var mi: = MeshInstance3D.new()
	mi.mesh = _make_mesh(kind)
	var mat: = StandardMaterial3D.new()
	mat.albedo_color = Color(0.88, 0.88, 0.86)
	mi.material_override = mat
	mi.set_meta("kind", kind)
	mi.set_meta("local_aabb", mi.mesh.get_aabb())
	_counters[kind] = int(_counters.get(kind, 0)) + 1
	mi.name = "%s%d" % [KINDS.get(kind, kind), _counters[kind]]
	add_child(mi)
	var aabb: AABB = mi.mesh.get_aabb()
	mi.global_position = Vector3(at.x, - aabb.position.y, at.z)
	_attach_label(mi, aabb)
	objects_changed.emit()
	return mi


func add_model(entry: Dictionary, cat_scale: float, at: Vector3) -> Node3D:
	var scene: = load(String(entry.file)) as PackedScene
	if scene == null:
		return null
	var root: = Node3D.new()
	var inst: = scene.instantiate()
	root.add_child(inst)
	root.set_meta("kind", "model")
	root.set_meta("model_id", String(entry.id))
	root.scale = Vector3.ONE * cat_scale
	var cn: = String(entry.get("cn", entry.id))
	_counters[cn] = int(_counters.get(cn, 0)) + 1
	root.name = "%s%d" % [cn, _counters[cn]]
	add_child(root)
	var aabb: = combined_aabb(root)
	root.set_meta("local_aabb", aabb)
	root.global_position = Vector3(at.x, - aabb.position.y * cat_scale, at.z)
	_attach_label(root, aabb)
	objects_changed.emit()
	return root


func _make_mesh(kind: String) -> Mesh:
	match kind:
		"box":
			var mb: = BoxMesh.new()
			mb.size = Vector3.ONE
			return mb
		"sphere":
			var ms: = SphereMesh.new()
			ms.radius = 0.5
			ms.height = 1.0
			return ms
		"cylinder":
			var mc: = CylinderMesh.new()
			mc.top_radius = 0.5
			mc.bottom_radius = 0.5
			mc.height = 1.0
			return mc
		"panel":
			var mp: = BoxMesh.new()
			mp.size = Vector3(2.0, 2.0, 0.12)
			return mp
		"ramp":
			var mr: = PrismMesh.new()
			mr.size = Vector3.ONE
			mr.left_to_right = 0.0
			return mr
	return BoxMesh.new()



static func combined_aabb(root: Node3D) -> AABB:
	var result: = AABB()
	var first: = true
	var inv_root: = root.global_transform.affine_inverse()
	var stack: Array = [root]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		if node is MeshInstance3D and (node as MeshInstance3D).mesh\
		and not String(node.name).begins_with("_Sel"):
			var mi: = node as MeshInstance3D
			var rel: Transform3D = inv_root * mi.global_transform
			var box: AABB = rel * mi.mesh.get_aabb()
			if first:
				result = box
				first = false
			else:
				result = result.merge(box)
		for child in node.get_children():
			if not (child is Label3D):
				stack.append(child)
	return result


func get_local_aabb(obj: Node3D) -> AABB:
	if obj.has_meta("local_aabb"):
		return obj.get_meta("local_aabb")
	return combined_aabb(obj)




func pick(origin: Vector3, dir: Vector3) -> Node3D:
	var best: Node3D = null
	var best_d: = INF
	for obj in list_objects():
		if not obj.visible:
			continue
		var inv: Transform3D = obj.global_transform.affine_inverse()
		var local_origin: Vector3 = inv * origin
		var local_dir: Vector3 = (inv.basis * dir).normalized()
		var aabb: = get_local_aabb(obj)
		var hit = aabb.intersects_ray(local_origin, local_dir)
		if hit != null:
			var global_hit: Vector3 = obj.global_transform * hit
			var d: = origin.distance_to(global_hit)
			if d < best_d:
				best_d = d
				best = obj
	return best


func _set_overlay(obj: Node3D, on: bool) -> void :
	if not is_instance_valid(obj):
		return
	var old: = obj.get_node_or_null("_SelOverlay")
	if old:
		old.free()
	if on:
		obj.add_child(_make_wire_box(get_local_aabb(obj)))


func _clear_overlays() -> void :
	for o in selected_list:
		if is_instance_valid(o):
			_set_overlay(o, false)



func select(obj: Node3D) -> void :
	_clear_overlays()
	selected_list = [obj] if obj != null else []
	selected = obj
	if obj:
		_set_overlay(obj, true)
	selection_changed.emit(obj)



func toggle_select(obj: Node3D) -> void :
	if obj == null:
		return
	if selected_list.has(obj):
		selected_list.erase(obj)
		_set_overlay(obj, false)
	else:
		selected_list.append(obj)
		_set_overlay(obj, true)
	selected = selected_list.back() if not selected_list.is_empty() else null
	selection_changed.emit(selected)



func select_many(arr: Array) -> void :
	_clear_overlays()
	selected_list = []
	for o in arr:
		if is_instance_valid(o):
			selected_list.append(o)
			_set_overlay(o, true)
	selected = selected_list.back() if not selected_list.is_empty() else null
	selection_changed.emit(selected)


static func _make_wire_box(aabb: AABB) -> MeshInstance3D:
	var im: = ImmediateMesh.new()
	im.surface_begin(Mesh.PRIMITIVE_LINES)
	var a: = aabb.position - aabb.size * 0.01
	var s: = aabb.size * 1.02
	var corners: = []
	for i in range(8):
		corners.append(a + Vector3(
			s.x * float(i & 1), s.y * float((i >> 1) & 1), s.z * float((i >> 2) & 1)))
	for e in [[0, 1], [2, 3], [4, 5], [6, 7], [0, 2], [1, 3], 
			[4, 6], [5, 7], [0, 4], [1, 5], [2, 6], [3, 7]]:
		im.surface_add_vertex(corners[e[0]])
		im.surface_add_vertex(corners[e[1]])
	im.surface_end()
	var overlay: = MeshInstance3D.new()
	overlay.name = "_SelOverlay"
	overlay.mesh = im
	var m: = StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = Color(0.16, 0.17, 0.2, 0.9)
	overlay.material_override = m
	overlay.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	overlay.layers = 2
	return overlay





func group_selected() -> Node3D:
	if selected_list.size() < 2:
		return null
	var members: = selected_list.duplicate()
	_clear_overlays()
	var group: = Node3D.new()
	group.set_meta("kind", "group")
	_counters["group"] = int(_counters.get("group", 0)) + 1
	group.name = "组%d" % _counters["group"]
	add_child(group)
	var world_tf: = {}
	for o in members:
		if not is_instance_valid(o):
			continue
		var gt: Transform3D = o.global_transform
		world_tf[o] = gt
		remove_child(o)
		group.add_child(o)
		o.global_transform = gt
		var lb: Node = o.get_node_or_null("_Label")
		if lb:
			(lb as Label3D).visible = false

	var center: = combined_aabb(group).get_center()
	group.global_position = center
	for o in members:
		if is_instance_valid(o) and world_tf.has(o):
			o.global_transform = world_tf[o]
	var aabb: = combined_aabb(group)
	group.set_meta("local_aabb", aabb)
	_attach_label(group, aabb)
	select(group)
	refresh_labels()
	objects_changed.emit()
	return group



func ungroup_selected() -> bool:
	var group: = selected
	if group == null or String(group.get_meta("kind", "")) != "group":
		return false
	var freed: Array = []
	for c in group.get_children().duplicate():
		if c is Node3D and c.has_meta("kind"):
			var gt: Transform3D = (c as Node3D).global_transform
			group.remove_child(c)
			add_child(c)
			(c as Node3D).global_transform = gt
			freed.append(c)
	select(null)
	group.queue_free()
	select_many(freed)
	refresh_labels()
	objects_changed.emit()
	return true




func _each_mesh(root: Node, fn: Callable) -> void :

	if root is MeshInstance3D and not String(root.name).begins_with("_"):
		fn.call(root)
	for child in root.get_children():
		_each_mesh(child, fn)


func set_selected_color(c: Color) -> void :
	if not selected:
		return
	for o in selected_list:
		if is_instance_valid(o):
			set_color_on(o, c)


func set_color_on(obj: Node3D, c: Color) -> void :
	var mat: = StandardMaterial3D.new()
	mat.albedo_color = c
	_each_mesh(obj, func(mi: MeshInstance3D) -> void :
		mi.material_override = mat)
	obj.set_meta("color", c)


func reset_selected_color() -> void :
	if not selected:
		return
	for o in selected_list:
		if not is_instance_valid(o):
			continue
		if String(o.get_meta("kind", "")) == "model":
			_each_mesh(o, func(mi: MeshInstance3D) -> void :
				mi.material_override = null)
			o.remove_meta("color")
		else:
			set_color_on(o, Color(0.88, 0.88, 0.86))


func get_selected_color() -> Color:
	if selected and selected.has_meta("color"):
		return selected.get_meta("color")
	return Color(0.88, 0.88, 0.86)




func delete_selected() -> void :
	if selected_list.is_empty():
		return
	var doomed: = selected_list.duplicate()
	select(null)
	for o in doomed:
		if is_instance_valid(o):
			o.queue_free()
	objects_changed.emit()


func duplicate_selected() -> Node3D:
	if selected_list.is_empty():
		return null
	var sources: = selected_list.duplicate()
	_clear_overlays()
	var copies: Array = []
	for src in sources:
		if is_instance_valid(src):
			copies.append(_duplicate_one(src))
	select_many(copies)
	refresh_labels()
	objects_changed.emit()
	return copies.back() if not copies.is_empty() else null


func _duplicate_one(src: Node3D) -> Node3D:
	var copy: = src.duplicate() as Node3D
	var ghost: = copy.get_node_or_null("_SelOverlay")
	if ghost:
		ghost.free()
	var kind: String = src.get_meta("kind")
	var label: String = KINDS.get(kind, "") if kind != "model" and kind != "group" else ""
	if kind == "group":
		label = "组"
	if label.is_empty():
		label = re_strip_digits(String(src.name))
	_counters[label] = int(_counters.get(label, 0)) + 1
	copy.name = "%s%d" % [label, _counters[label]]
	add_child(copy)
	copy.global_position = src.global_position + Vector3(1.0, 0.0, 1.0)
	if copy.has_meta("color"):
		set_color_on(copy, copy.get_meta("color"))
	return copy


static func re_strip_digits(s: String) -> String:
	var out: = s
	while not out.is_empty() and out[-1].is_valid_int():
		out = out.substr(0, out.length() - 1)
	return out if not out.is_empty() else s


func count_objects() -> int:
	return list_objects().size()


func clear_objects() -> void :
	select(null)
	for obj in get_children():
		obj.queue_free()
	objects_changed.emit()


func list_objects() -> Array:
	var out: = []
	for obj in get_children():
		if obj is Node3D and obj.has_meta("kind") and not obj.is_queued_for_deletion():
			out.append(obj)
	return out




func serialize() -> Array:
	var out: = []
	for obj in list_objects():
		out.append(_serialize_node(obj))
	return out


func _serialize_node(obj: Node3D) -> Dictionary:
	var d: = {
		"kind": obj.get_meta("kind"), 
		"name": String(obj.name), 
		"pos": [obj.position.x, obj.position.y, obj.position.z], 
		"rot": [obj.rotation_degrees.x, obj.rotation_degrees.y, obj.rotation_degrees.z], 
		"scale": [obj.scale.x, obj.scale.y, obj.scale.z], 
		"visible": obj.visible, 
	}
	if obj.has_meta("model_id"):
		d["model_id"] = obj.get_meta("model_id")
	if obj.has_meta("figure_type"):
		d["ftype"] = obj.get_meta("figure_type")
		d["pose"] = obj.get_meta("figure_pose")
	if obj.has_meta("color"):
		d["color"] = (obj.get_meta("color") as Color).to_html(false)
	if String(obj.get_meta("kind")) == "group":
		var children: = []
		for c in obj.get_children():
			if c is Node3D and c.has_meta("kind"):
				children.append(_serialize_node(c))
		d["children"] = children
	return d


func load_objects(arr: Array, model_lookup: Dictionary = {}) -> void :
	clear_objects()
	for d in arr:
		_load_entry(d, model_lookup)
	refresh_labels()
	objects_changed.emit()


func _load_entry(d: Dictionary, model_lookup: Dictionary) -> Node3D:
	var kind: = String(d.get("kind", "box"))
	var obj: Node3D = null
	if kind == "group":
		obj = Node3D.new()
		obj.set_meta("kind", "group")
		add_child(obj)
		for cd in d.get("children", []):
			var child: = _load_entry(cd, model_lookup)
			if child:
				var gt: Transform3D = child.transform
				remove_child(child)
				obj.add_child(child)
				child.transform = gt
				var clb: = child.get_node_or_null("_Label")
				if clb:
					clb.visible = false
		var gaabb: = combined_aabb(obj)
		obj.set_meta("local_aabb", gaabb)
		_attach_label(obj, gaabb)
	elif kind == "model":
		var mid: = String(d.get("model_id", ""))
		if model_lookup.has(mid):
			var info: Dictionary = model_lookup[mid]
			obj = add_model(info.entry, float(info.cat_scale), Vector3.ZERO)
		else:
			push_warning("模型缺失,已跳过:" + mid)
			return null
	elif kind == "figure":
		obj = add_figure(Vector3.ZERO, String(d.get("ftype", "standard")), 
			String(d.get("pose", "站立")))
	else:
		obj = add_primitive(kind, Vector3.ZERO)
	obj.name = d.get("name", String(obj.name))
	obj.position = _arr_v3(d.get("pos", [0, 0, 0]))
	obj.rotation_degrees = _arr_v3(d.get("rot", [0, 0, 0]))
	obj.scale = _arr_v3(d.get("scale", [1, 1, 1]))
	obj.visible = bool(d.get("visible", true))
	if d.has("color"):
		set_color_on(obj, Color.from_string(String(d.color), Color.WHITE))
	return obj


func _arr_v3(a: Array) -> Vector3:
	return Vector3(float(a[0]), float(a[1]), float(a[2]))
