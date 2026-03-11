class_name StateScope
extends StateNode

func _enter_tree() -> void:
	var parent_registry := _find_nearest_scope(false)
	_owner = get_parent()
	_registry = ScopeRegistry.new(parent_registry, _owner)
	_owner.set_meta(SCOPE_REGISTRY_META_KEY, _registry)
