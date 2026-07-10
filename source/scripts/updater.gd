class_name Updater
extends Node

# Update compatibility module. In-app update checks and executable replacement
# are not enabled in the current desktop build.

signal status(msg: String)
signal update_available(info: Dictionary)
signal download_progress(percent: float)
signal ready_to_install(new_exe: String)
signal failed(msg: String)
signal up_to_date

var manifest_url: = ""
var app_version: = "0.0.0"


static func version_newer(a: String, b: String) -> bool:
	var pa: = a.strip_edges().trim_prefix("v").split(".")
	var pb: = b.strip_edges().trim_prefix("v").split(".")
	for i in range(maxi(pa.size(), pb.size())):
		var na: = int(pa[i]) if i < pa.size() else 0
		var nb: = int(pb[i]) if i < pb.size() else 0
		if na != nb:
			return na > nb
	return false


func check(_silent: = true) -> void:
	status.emit("当前版本未启用应用内更新")
	up_to_date.emit()


func apply_update(_info: Dictionary) -> void:
	failed.emit("当前版本不支持应用内更新")


func install(_new_exe: String) -> bool:
	failed.emit("当前版本不支持应用内更新")
	return false


func _extract_hpatchz() -> String:
	return ""
