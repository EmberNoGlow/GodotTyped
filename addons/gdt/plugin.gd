@tool
@icon("res://addons/gdt/assets/mini-icon.svg")
extends EditorPlugin

var lang_instance   : GodotTypedLanguage
var loader_instance : GodotTypedScriptLoader
var saver_instance  : GodotTypedScriptSaver
var highlighter     : GDTSyntaxHighlighter

var _cached_icon: Texture2D
var _script_list: ItemList

func _enter_tree() -> void:
	_cached_icon = load("res://addons/gdt/assets/mini-icon.svg")
	GodotTypedSyntaxConfig.make_keywords()
	register()

	# ScriptDialog hack
	var base := EditorInterface.get_base_control()
	var dialogs := base.find_children("*", "ScriptCreateDialog", true, false)
	for dialog in dialogs:
		var option_buttons := dialog.find_children("*", "OptionButton", true, false)
		for btn: OptionButton in option_buttons:
			if btn.item_count > 0 and btn.get_item_text(0) == "GDScript":
				var lang_idx := Engine.get_script_language_count() - 1
				btn.add_icon_item(_cached_icon, "Typed Script", lang_idx)

	var script_editor := EditorInterface.get_script_editor()
	var item_lists := script_editor.find_children("*", "ItemList", true, false)
	if item_lists.size() > 0:
		_script_list = item_lists[0]

func _process(_delta: float) -> void:
	if not is_instance_valid(_script_list):
		return

	# Editor Script hack
	for i in _script_list.item_count:
		var item_text := _script_list.get_item_text(i).trim_suffix("(*)")
		if item_text.ends_with(".gdt"):
			if _script_list.get_item_icon(i) != _cached_icon:
				_script_list.set_item_icon(i, _cached_icon)

func _exit_tree() -> void:
	unregister()

# Register instances
func register() -> void:
	lang_instance   = GodotTypedLanguage.new()
	loader_instance = GodotTypedScriptLoader.new()
	saver_instance  = GodotTypedScriptSaver.new()
	highlighter     = GDTSyntaxHighlighter.new()

	Engine.register_script_language(lang_instance)
	ResourceLoader.add_resource_format_loader(loader_instance)
	ResourceSaver.add_resource_format_saver(saver_instance)
	EditorInterface.get_script_editor().register_syntax_highlighter(highlighter)

# Free
func unregister() -> void:
	Engine.unregister_script_language(lang_instance)
	ResourceLoader.remove_resource_format_loader(loader_instance)
	ResourceSaver.remove_resource_format_saver(saver_instance)
	EditorInterface.get_script_editor().unregister_syntax_highlighter(highlighter)
