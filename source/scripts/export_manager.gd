class_name ExportManager
extends Node




signal status(msg: String)
signal finished(ok: bool, result: String)

enum State{IDLE, RENDERING, ENCODING}

var state: int = State.IDLE
var fps: = 30

var render_w: = 1920
var render_h: = 1080
var crop: = Rect2i(0, 0, 1920, 1080)

var _pid: = -1
var _avi: = ""
var _mp4: = ""


func start_export(mp4_path: String) -> void :
	if state != State.IDLE:
		status.emit("已有导出任务进行中")
		return
	_mp4 = mp4_path
	_avi = mp4_path + ".tmp.avi"
	var args: = PackedStringArray()
	if OS.has_feature("editor"):
		args.append_array(["--path", ProjectSettings.globalize_path("res://")])
	args.append_array([
		"--write-movie", _avi, 
		"--fixed-fps", str(fps), 
		"--resolution", "%dx%d" % [render_w, render_h], 
		"++", "--previz-render", 
	])
	_pid = OS.create_process(OS.get_executable_path(), args)
	if _pid <= 0:
		finished.emit(false, "无法启动渲染进程")
		return
	state = State.RENDERING
	status.emit("正在逐帧渲染…(会弹出渲染窗口,渲染完自动关闭)")


func _process(_delta: float) -> void :
	if state == State.IDLE:
		return
	if OS.is_process_running(_pid):
		return
	if state == State.RENDERING:
		_start_encode()
	elif state == State.ENCODING:
		_finish()


func _start_encode() -> void :
	if not FileAccess.file_exists(_avi):
		state = State.IDLE
		finished.emit(false, "渲染失败:未生成中间文件")
		return
	var ff: = _ffmpeg_path()
	if ff.is_empty():
		state = State.IDLE
		finished.emit(false, "找不到 ffmpeg.exe(应与程序放在同一目录)")
		return


	var vf: = "crop=%d:%d:%d:%d,scale=1920:1080:force_original_aspect_ratio=decrease:force_divisible_by=2,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:color=black" % [
		crop.size.x, crop.size.y, crop.position.x, crop.position.y]
	_pid = OS.create_process(ff, PackedStringArray([
		"-y", "-i", _avi, 
		"-vf", vf, 
		"-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "18", 
		"-movflags", "+faststart", _mp4, 
	]))
	if _pid <= 0:
		state = State.IDLE
		finished.emit(false, "无法启动 ffmpeg")
		return
	state = State.ENCODING
	status.emit("正在编码 mp4…")


func _finish() -> void :
	state = State.IDLE
	var sz: = 0
	if FileAccess.file_exists(_mp4):
		var f: = FileAccess.open(_mp4, FileAccess.READ)
		if f:
			sz = int(f.get_length())
	if sz > 1024:
		DirAccess.remove_absolute(_avi)
		finished.emit(true, _mp4)
	else:

		finished.emit(false, "编码失败:成片为空(0KB)——请重试或反馈")


func _ffmpeg_path() -> String:

	var local: = OS.get_executable_path().get_base_dir().path_join("ffmpeg.exe")
	if FileAccess.file_exists(local):
		return local

	var packaged_dependency: = ProjectSettings.globalize_path("res://../ffmpeg.exe").simplify_path()
	if FileAccess.file_exists(packaged_dependency):
		return packaged_dependency

	return _extract_bundled_ffmpeg()




func _extract_bundled_ffmpeg() -> String:
	var out: = ProjectSettings.globalize_path("user://ffmpeg.exe")

	if FileAccess.file_exists(out):
		var chk: = FileAccess.open(out, FileAccess.READ)
		if chk and chk.get_length() > 1024 * 1024:
			chk.close()
			return out
	var src: = "res://bin/ffmpeg.exe"
	if not FileAccess.file_exists(src):
		return ""
	status.emit("首次导出:正在准备内置编码器…")
	var data: = FileAccess.get_file_as_bytes(src)
	if data.is_empty():
		return ""
	var f: = FileAccess.open(out, FileAccess.WRITE)
	if f == null:
		return ""
	f.store_buffer(data)
	f.close()
	return out
