class_name FigureLib
extends RefCounted





const JOINTS: = ["J_pelvis", "J_spine", "J_neck", 
	"J_shoulder_l", "J_elbow_l", "J_shoulder_r", "J_elbow_r", 
	"J_hip_l", "J_knee_l", "J_hip_r", "J_knee_r"]


const BODY_TYPES: = {
	"standard": {"cn": "标准素体", "h": 1.0, "head": 1.0, "sh": 1.0, 
		"hip": 1.0, "limb": 1.0, "torso": 1.0}, 
	"female": {"cn": "女性素体", "h": 0.95, "head": 0.96, "sh": 0.86, 
		"hip": 1.1, "limb": 0.85, "torso": 0.88}, 
	"child": {"cn": "儿童素体", "h": 0.62, "head": 1.4, "sh": 0.9, 
		"hip": 0.95, "limb": 0.95, "torso": 1.0}, 
	"heavy": {"cn": "壮实素体", "h": 1.0, "head": 1.02, "sh": 1.18, 
		"hip": 1.2, "limb": 1.45, "torso": 1.4}, 
	"slim": {"cn": "纤细素体", "h": 1.06, "head": 0.94, "sh": 0.9, 
		"hip": 0.85, "limb": 0.72, "torso": 0.8}, 
}





const POSES: = {
	"站立": {}, 
	"T型": {"J_shoulder_l": [0, 0, -83], "J_shoulder_r": [0, 0, 83]}, 
	"行走": {"J_hip_l": [28, 0, 0], "J_knee_l": [-12, 0, 0], 
		"J_hip_r": [-22, 0, 0], "J_knee_r": [-35, 0, 0], 
		"J_shoulder_l": [-24, 0, 0], "J_shoulder_r": [26, 0, 0], 
		"J_elbow_l": [18, 0, 0], "J_elbow_r": [30, 0, 0]}, 
	"跑步": {"J_hip_l": [55, 0, 0], "J_knee_l": [-35, 0, 0], 
		"J_hip_r": [-40, 0, 0], "J_knee_r": [-95, 0, 0], 
		"J_shoulder_l": [-45, 0, 0], "J_shoulder_r": [50, 0, 0], 
		"J_elbow_l": [70, 0, 0], "J_elbow_r": [80, 0, 0], 
		"J_spine": [-12, 0, 0]}, 
	"跳跃": {"J_hip_l": [70, 0, 0], "J_knee_l": [-90, 0, 0], 
		"J_hip_r": [15, 0, 0], "J_knee_r": [-30, 0, 0], 
		"J_shoulder_l": [160, 0, -15], "J_shoulder_r": [160, 0, 15], 
		"J_spine": [8, 0, 0]}, 
	"踢球": {"J_hip_r": [75, 0, 0], "J_knee_r": [-15, 0, 0], 
		"J_hip_l": [-12, 0, 0], 
		"J_shoulder_l": [35, 0, -20], "J_shoulder_r": [-30, 0, 20], 
		"J_spine": [6, 0, 0]}, 
	"投掷": {"J_shoulder_r": [140, 0, 30], "J_elbow_r": [70, 0, 0], 
		"J_shoulder_l": [40, 0, -25], 
		"J_spine": [10, 15, 0], "J_hip_l": [20, 0, 0], "J_hip_r": [-15, 0, 0]}, 
	"推": {"J_shoulder_l": [80, 0, 0], "J_shoulder_r": [80, 0, 0], 
		"J_elbow_l": [15, 0, 0], "J_elbow_r": [15, 0, 0], 
		"J_spine": [-18, 0, 0], "J_hip_l": [35, 0, 0], "J_knee_l": [-25, 0, 0], 
		"J_hip_r": [-25, 0, 0], "J_knee_r": [-20, 0, 0]}, 
	"坐姿": {"J_hip_l": [88, 0, 0], "J_knee_l": [-88, 0, 0], 
		"J_hip_r": [88, 0, 0], "J_knee_r": [-88, 0, 0], 
		"J_shoulder_l": [25, 0, 0], "J_shoulder_r": [25, 0, 0], 
		"J_elbow_l": [25, 0, 0], "J_elbow_r": [25, 0, 0]}, 
	"蹲下": {"J_hip_l": [110, 0, 0], "J_knee_l": [-125, 0, 0], 
		"J_hip_r": [110, 0, 0], "J_knee_r": [-125, 0, 0], 
		"J_spine": [-20, 0, 0], 
		"J_shoulder_l": [55, 0, 0], "J_shoulder_r": [55, 0, 0], 
		"J_elbow_l": [40, 0, 0], "J_elbow_r": [40, 0, 0]}, 
	"单膝跪": {"J_hip_l": [90, 0, 0], "J_knee_l": [-90, 0, 0], 
		"J_hip_r": [0, 0, 0], "J_knee_r": [-90, 0, 0], 
		"J_spine": [-8, 0, 0], "J_shoulder_l": [30, 0, 0]}, 
	"双膝跪": {"J_hip_l": [0, 0, 0], "J_knee_l": [-90, 0, 0], 
		"J_hip_r": [0, 0, 0], "J_knee_r": [-90, 0, 0], 
		"J_spine": [-5, 0, 0]}, 
	"指向": {"J_shoulder_r": [85, 0, 0], "J_elbow_r": [0, 0, 0], 
		"J_neck": [0, -12, 0]}, 
	"举手": {"J_shoulder_r": [175, 0, 10]}, 
	"庆祝": {"J_shoulder_l": [170, 0, -25], "J_shoulder_r": [170, 0, 25], 
		"J_elbow_l": [20, 0, 0], "J_elbow_r": [20, 0, 0], 
		"J_spine": [10, 0, 0], "J_neck": [12, 0, 0]}, 
	"鞠躬": {"J_spine": [-55, 0, 0], "J_neck": [-15, 0, 0], 
		"J_shoulder_l": [10, 0, 0], "J_shoulder_r": [10, 0, 0]}, 
	"演讲": {"J_shoulder_r": [55, 0, 25], "J_elbow_r": [55, 0, 0], 
		"J_shoulder_l": [15, 0, -10]}, 
	"叉腰": {"J_shoulder_l": [0, 0, -42], "J_elbow_l": [0, 0, 85], 
		"J_shoulder_r": [0, 0, 42], "J_elbow_r": [0, 0, -85]}, 
	"抱臂": {"J_shoulder_l": [72, 0, 22], "J_elbow_l": [0, -95, 0], 
		"J_shoulder_r": [72, 0, -22], "J_elbow_r": [0, 95, 0]}, 
	"思考": {"J_shoulder_r": [95, 0, 15], "J_elbow_r": [125, 0, 0], 
		"J_shoulder_l": [40, 0, -15], "J_elbow_l": [0, -90, 0], 
		"J_neck": [-10, 15, 0], "J_spine": [-5, 0, 0]}, 
	"倚靠": {"J_spine": [8, 0, 8], "J_hip_l": [8, 0, 5], 
		"J_hip_r": [-5, 0, -8], "J_knee_r": [-25, 0, 0], 
		"J_shoulder_l": [10, 0, -20], "J_shoulder_r": [45, 0, 20], 
		"J_elbow_r": [0, 90, 0]}, 
	"伸懒腰": {"J_shoulder_l": [165, 0, -30], "J_shoulder_r": [165, 0, 30], 
		"J_spine": [15, 0, 0], "J_neck": [15, 0, 0]}, 
	"看手机": {"J_shoulder_l": [55, 0, 0], "J_elbow_l": [95, 0, 0], 
		"J_shoulder_r": [55, 0, 0], "J_elbow_r": [95, 0, 0], 
		"J_neck": [-28, 0, 0], "J_spine": [-8, 0, 0]}, 
	"拍照": {"J_shoulder_l": [90, 0, 0], "J_elbow_l": [90, 0, 0], 
		"J_shoulder_r": [90, 0, 0], "J_elbow_r": [90, 0, 0], 
		"J_neck": [-5, 0, 0]}, 
	"格斗": {"J_shoulder_l": [70, 0, -15], "J_elbow_l": [115, 0, 0], 
		"J_shoulder_r": [55, 0, 20], "J_elbow_r": [125, 0, 0], 
		"J_spine": [-10, -20, 0], "J_hip_l": [25, 0, 0], "J_knee_l": [-20, 0, 0], 
		"J_hip_r": [-15, 0, 0], "J_knee_r": [-25, 0, 0]}, 
	"舞蹈": {"J_shoulder_l": [170, 0, -35], "J_elbow_l": [30, 0, 0], 
		"J_shoulder_r": [40, 0, 60], "J_elbow_r": [45, 0, 0], 
		"J_spine": [5, 0, 12], "J_hip_l": [20, 0, 15], "J_knee_l": [-30, 0, 0], 
		"J_hip_r": [-10, 0, -8]}, 
}


static func _mat() -> StandardMaterial3D:
	var m: = StandardMaterial3D.new()
	m.albedo_color = Color(0.88, 0.88, 0.86)
	return m


static func _capsule(mat: Material, r: float, h: float, pos: Vector3) -> MeshInstance3D:
	var mi: = MeshInstance3D.new()
	var mesh: = CapsuleMesh.new()
	mesh.radius = r
	mesh.height = maxf(h, r * 2.05)
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	return mi


static func _sphere(mat: Material, r: float, pos: Vector3, h_scale: = 1.0) -> MeshInstance3D:
	var mi: = MeshInstance3D.new()
	var mesh: = SphereMesh.new()
	mesh.radius = r
	mesh.height = r * 2.0 * h_scale
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	return mi


static func _box(mat: Material, size: Vector3, pos: Vector3) -> MeshInstance3D:
	var mi: = MeshInstance3D.new()
	var mesh: = BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	return mi


static func _joint(parent: Node3D, jname: String, pos: Vector3) -> Node3D:
	var j: = Node3D.new()
	j.name = jname
	j.position = pos
	parent.add_child(j)
	return j



static func build(root: Node3D, body_type: String) -> void :
	var p: Dictionary = BODY_TYPES.get(body_type, BODY_TYPES.standard)
	var h: float = p.h
	var mat: = _mat()
	var limb: float = p.limb
	var torso: float = p.torso


	var pelvis: = _joint(root, "J_pelvis", Vector3(0, 0.96 * h, 0))
	pelvis.add_child(_box(mat, Vector3(0.28 * p.hip, 0.15, 0.16 * torso) * h, 
		Vector3.ZERO))


	var spine: = _joint(pelvis, "J_spine", Vector3(0, 0.09 * h, 0))
	spine.add_child(_capsule(mat, 0.15 * torso * h, 0.5 * h, Vector3(0, 0.25 * h, 0)))
	var neck: = _joint(spine, "J_neck", Vector3(0, 0.47 * h, 0))
	neck.add_child(_capsule(mat, 0.04 * h, 0.09 * h, Vector3(0, 0.02 * h, 0)))
	var head_r: float = 0.105 * p.head * h
	neck.add_child(_sphere(mat, head_r, Vector3(0, 0.055 * h + head_r, 0), 1.22))

	var eye_mat: = StandardMaterial3D.new()
	eye_mat.albedo_color = Color(0.16, 0.17, 0.2)
	for side in [-1.0, 1.0]:
		var eye: = _sphere(eye_mat, 0.012 * h, 
			Vector3(side * 0.035 * h, 0.055 * h + head_r * 1.12, 
			- head_r * 0.88))
		eye.name = "_FaceEyeL" if side < 0 else "_FaceEyeR"
		neck.add_child(eye)
	var mouth: = _box(eye_mat, Vector3(0.028, 0.006, 0.004) * h, 
		Vector3(0, 0.055 * h + head_r * 0.72, - head_r * 0.94))
	mouth.name = "_FaceMouth"
	neck.add_child(mouth)


	for side_data in [["l", -1.0], ["r", 1.0]]:
		var s: String = side_data[0]
		var sd: float = side_data[1]
		var shoulder: = _joint(spine, "J_shoulder_" + s, 
			Vector3(sd * 0.205 * p.sh * h, 0.4 * h, 0))
		shoulder.add_child(_capsule(mat, 0.042 * limb * h, 0.26 * h, 
			Vector3(0, -0.13 * h, 0)))
		var elbow: = _joint(shoulder, "J_elbow_" + s, Vector3(0, -0.27 * h, 0))
		elbow.add_child(_capsule(mat, 0.037 * limb * h, 0.24 * h, 
			Vector3(0, -0.12 * h, 0)))
		elbow.add_child(_sphere(mat, 0.046 * limb * h, Vector3(0, -0.27 * h, 0)))


	for side_data in [["l", -1.0], ["r", 1.0]]:
		var s: String = side_data[0]
		var sd: float = side_data[1]
		var hip: = _joint(pelvis, "J_hip_" + s, 
			Vector3(sd * 0.085 * p.hip * h, -0.06 * h, 0))
		hip.add_child(_capsule(mat, 0.06 * limb * h, 0.38 * h, 
			Vector3(0, -0.19 * h, 0)))
		var knee: = _joint(hip, "J_knee_" + s, Vector3(0, -0.39 * h, 0))
		knee.add_child(_capsule(mat, 0.05 * limb * h, 0.36 * h, 
			Vector3(0, -0.18 * h, 0)))
		knee.add_child(_box(mat, Vector3(0.085, 0.055, 0.2) * h, 
			Vector3(0, -0.4 * h, -0.045 * h)))



static func apply_pose(root: Node3D, pose_name: String) -> void :
	var pose: Dictionary = POSES.get(pose_name, {})
	for jname in JOINTS:
		var j: = root.find_child(jname, true, false) as Node3D
		if j == null:
			continue
		var e: Array = pose.get(jname, [0, 0, 0])
		j.rotation_degrees = Vector3(float(e[0]), float(e[1]), float(e[2]))




static func blend_pose(root: Node3D, pose_a: String, pose_b: String, u: float) -> void :
	var pa: Dictionary = POSES.get(pose_a, {})
	var pb: Dictionary = POSES.get(pose_b, {})
	for jname in JOINTS:
		var j: = root.find_child(jname, true, false) as Node3D
		if j == null:
			continue
		var ea: Array = pa.get(jname, [0, 0, 0])
		var eb: Array = pb.get(jname, [0, 0, 0])
		var qa: = Quaternion.from_euler(Vector3(
			deg_to_rad(float(ea[0])), deg_to_rad(float(ea[1])), deg_to_rad(float(ea[2]))))
		var qb: = Quaternion.from_euler(Vector3(
			deg_to_rad(float(eb[0])), deg_to_rad(float(eb[1])), deg_to_rad(float(eb[2]))))
		j.quaternion = qa.slerp(qb, clampf(u, 0.0, 1.0))
