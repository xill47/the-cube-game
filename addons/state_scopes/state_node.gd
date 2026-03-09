@abstract
class_name StateNode
extends Node

signal state_resolved

const SCOPE_REGISTRY_META_KEY := &"_scope_registry"
const ScopeRegistry: Script = preload("res://addons/state_scopes/scope_registry.gd")

static var _state_classes_map: Dictionary[StringName, Array] = {}
static var _global_class_list_count: int = 0

var _owner: Node
var _registry: ScopeRegistry

func _enter_tree() -> void:
	_owner = get_parent()
	_registry = _find_nearest_scope(true)

func _find_nearest_scope(create_new: bool) -> ScopeRegistry:
	if _registry != null:
		return _registry
	var node: Node = get_parent()
	while node != null:
		if node.has_meta(SCOPE_REGISTRY_META_KEY):
			return node.get_meta(SCOPE_REGISTRY_META_KEY)
		node = node.get_parent()

	if create_new:
		var root: Node = get_tree().get_root()
		var scope_registry: ScopeRegistry = ScopeRegistry.new(null, root)
		root.set_meta(SCOPE_REGISTRY_META_KEY, scope_registry)
		return scope_registry
	return null

static func _extends(klass_name: StringName, base_class_name: StringName) -> bool:
	if klass_name == base_class_name:
		return true
	_ensure_class_map()
	return _state_classes_map.get(base_class_name, []).has(klass_name)

static func _get_derived_classes(base_class_name: StringName) -> Array:
	_ensure_class_map()
	return _state_classes_map.get(base_class_name, [])

static func _ensure_class_map() -> void:
	var global_class_list := ProjectSettings.get_global_class_list()
	if _state_classes_map == null or _global_class_list_count != global_class_list.size():
		# for A extends B
		var class_map: Dictionary[StringName, Array] = {} # B -> [A]
		var reverse_class_map: Dictionary[StringName, StringName] = {} # A -> B
		for global_class_def in global_class_list:
			var base: StringName = global_class_def.get("base")
			var name: StringName = global_class_def.get("class")
			reverse_class_map.set(name, base)

		for global_class_def in global_class_list:
			var base: StringName = global_class_def.get("base")
			var name: StringName = global_class_def.get("class")
			var curr_base := base
			while curr_base != &"":
				var extends_array = class_map.get_or_add(curr_base, [])
				extends_array.push_back(name)
				curr_base = reverse_class_map.get(curr_base, &"")

		_state_classes_map = class_map
		_global_class_list_count = global_class_list.size()



static func _has_resolvable_constructor(klass_name: StringName, owner: Node) -> bool:
	var script: Script = ScopeRegistry._find_script(klass_name)
	var owner_script: Script = owner.get_script()
	if script == null or owner_script == null:
		return false

	var owner_class := owner_script.get_global_name()
	if not script.has_method(&"create"):
		return false

	for method_info in script.get_script_method_list():
		if method_info.get(&"name") == "create":
			var arguments = method_info.get(&"args")
			for arg in arguments:
				var arg_class: StringName = arg.get(&"class_name")
				if not _extends(arg_class, &"State") and arg_class != owner_class:
					return false
			return true

	return false
