class_name StateProvider
extends StateNode
## Marks parent node as a state provider.
## Parent node should have at least one property of type [State].
##
## The first [State] property that is either set or have static [method create] method
## with at most one node argument (of this node parent) and any other [State] arguments
## will be provided.
## In the case when [method create] method has more than one [State] argument of the same type,
## they will be resolved by their argument names.
##
## If multiple [State] properties satisfy the above criteria, only the first one will be provided.

## Identifier of the provided state, in case there are multiple states of the same type.
## If not set, lowercased name of the parent node will be used.
@export var identifier: StringName = &""

func _enter_tree() -> void:
	super()
	for prop in _owner.get_property_list():
		var klass_name = prop.get("class_name", &"")
		var prop_name = prop.get("name", &"")
		var effective_id := identifier if identifier != &"" else _owner.name.to_lower()
		if _extends(klass_name, &"State") :
			var current = _owner.get(prop_name)
			if current != null:
				_registry.provide(klass_name, effective_id, current)
				return
			if _has_resolvable_constructor(klass_name, _owner):
				_registry.require_by_constructor(klass_name, _owner, prop_name, \
					_on_resolved.bind(klass_name, effective_id, prop_name))
				return

func _on_resolved(klass_name: StringName, effective_id: StringName, prop_name: StringName) -> void:
	_registry.provide(klass_name, effective_id, _owner.get(prop_name))
	state_resolved.emit()
