@tool
extends EditorPlugin

var lang_instance   : GodotTypedLanguage
var loader_instance : GodotTypedScriptLoader
var saver_instance  : GodotTypedScriptSaver

func _enter_tree() -> void:
	register()

func _exit_tree() -> void:
	unregister()

# Register instances
func register() -> void:
	lang_instance   = GodotTypedLanguage.new()
	loader_instance = GodotTypedScriptLoader.new()
	saver_instance  = GodotTypedScriptSaver.new()
	
	Engine.register_script_language(lang_instance)
	ResourceLoader.add_resource_format_loader(loader_instance)
	ResourceSaver.add_resource_format_saver(saver_instance)

# Free
func unregister() -> void:
	Engine.unregister_script_language(lang_instance)
	ResourceLoader.remove_resource_format_loader(loader_instance)
	ResourceSaver.remove_resource_format_saver(saver_instance)
