class_name AuthClient
extends Node

# Local session compatibility module. The current desktop build does not
# require an account service.

signal login_ok(user: Dictionary)
signal login_failed(msg: String)
signal authed(user: Dictionary, online: bool)
signal need_login
signal blocked(msg: String)
signal need_online(msg: String)

var base_url: = ""
var app_version: = "0.0.0"
var token: = "local"
var user: Dictionary = {"nickname": "本地用户"}


func has_token() -> bool:
	return true


func nickname() -> String:
	return String(user.nickname)


func login(_account: String, _password: String) -> void:
	login_ok.emit(user)


func verify() -> void:
	authed.emit(user, false)


func heartbeat() -> void:
	pass


func logout() -> void:
	pass
