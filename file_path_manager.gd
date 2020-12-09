extends Object

class_name FilePathManager

var absolute_path:="" setget set_absolute_path
var relative_path:="" setget set_relative_path

func set_relative_path(new_path:String):
	relative_path = new_path
	if _get_relative_path(absolute_path)!=relative_path:
		absolute_path = _get_absolute_from_relative(relative_path)
func set_absolute_path(new_path:String):
	absolute_path = new_path
	if _get_relative_path(absolute_path)!=relative_path:
		relative_path = _get_relative_path(absolute_path)

func get_path()->String:
	_resync()
	if relative_path != "":
		return relative_path
	elif absolute_path != "":
		return absolute_path
	else:
		return ""

func has_path(path:String)->bool:
	_resync()
	if path!="":
		if path.is_abs_path():
			return path==absolute_path or _get_relative_path(path)==relative_path
		else:
			return path==relative_path
	else:
		return absolute_path=="" and relative_path==""

func is_valid()->bool:
	_resync()
	return !(absolute_path=="" and relative_path=="")

#Param (absolute path,relative path) or can be use with (absolute path) or (relative path)
func _init(new_path:String="",new_relative_path:String=""):
	if new_path=="":
		absolute_path=_fix(_get_absolute_from_relative(new_relative_path))
		relative_path=_fix(new_relative_path)
	elif new_path.is_abs_path():
		absolute_path=_fix(new_path)
		if new_relative_path=="":
			relative_path=_get_relative_path(absolute_path)
		else:
			relative_path=_fix(new_relative_path)
	else:
		absolute_path=_fix(_get_absolute_from_relative(new_path))
		relative_path=_fix(new_path)

func _get_relative_path(path:String)->String:
	var path_dir = Global.app_path.get_base_dir()+"/"
	if path_dir in path:
		return path.replace(path_dir, "")
	return ""

func _get_absolute_from_relative(path:String)->String:
	return Global.app_path.get_base_dir()+"/"+path

func _fix(path:String)->String:
	var directory = Directory.new();
	if path!="" and directory.file_exists(path if path.is_abs_path() else "res://"+path):
		return path
	else:
		return ""

func _resync():
	relative_path=_fix(relative_path)
	absolute_path=_fix(absolute_path)
	if absolute_path!="" and relative_path!="":
		if absolute_path != _get_absolute_from_relative(relative_path):
			absolute_path=""
