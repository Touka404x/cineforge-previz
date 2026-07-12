class_name NovelAgentRunner
extends RefCounted


const INPUT_PATH: = "user://novel_agent_input.txt"
const OUTPUT_PATH: = "user://novel_agent_plan.json"


func analyze(text: String) -> Dictionary:
	var input_file: = FileAccess.open(INPUT_PATH, FileAccess.WRITE)
	if input_file == null:
		return {"ok": false, "error": "无法写入本地小说输入文件。"}
	input_file.store_string(text)
	input_file.flush()

	var script_path: = ProjectSettings.globalize_path("res://agent/previz_agent.py")
	var catalog_path: = ProjectSettings.globalize_path("res://models_index.json")
	if not FileAccess.file_exists(script_path):
		return {"ok": false, "error": "缺少本地 Agent 脚本。"}
	var python_bin: = OS.get_environment("PREVIZ_AGENT_PYTHON")
	if python_bin.is_empty():
		python_bin = "python"
	var output: Array = []
	var code: = OS.execute(python_bin, PackedStringArray([
		script_path, "plan", "--input", ProjectSettings.globalize_path(INPUT_PATH),
		"--output", ProjectSettings.globalize_path(OUTPUT_PATH), "--catalog", catalog_path,
	]), output, true)
	if code != 0:
		return {"ok": false, "error": "Agent 未能完成分析: " + "\n".join(PackedStringArray(output))}
	var raw: = FileAccess.get_file_as_string(OUTPUT_PATH)
	var result = JSON.parse_string(raw)
	if typeof(result) != TYPE_DICTIONARY:
		return {"ok": false, "error": "Agent 返回的计划文件无效。"}
	var validation: Dictionary = result.get("validation", {})
	var deterministic: Dictionary = validation.get("deterministic", {})
	if not bool(deterministic.get("approved", false)):
		return {"ok": false, "error": "Agent 计划没有通过结构校验。"}
	return {"ok": true, "result": result}
