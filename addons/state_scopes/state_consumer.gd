class_name StateConsumer
extends StateNode
## Marks parent node as a state consumer.
## Parent node can have any number of properties of type [State].
##
## Any of the [State] properties that aren't set yet will be resolved (either immediately).
## If the parent node is also a state provider, the provided state will be ignored.


## Optional identifiers for parent states, in case there are multiple states of the same type.
## If not set, lowercased name of the property will be used.
@export var states_identifiers: Dictionary[StringName, StringName]

func _enter_tree() -> void:
	super()
	var ignored_property := _get_provided_property_name()
	for prop in _owner.get_property_list():
		var klass_name: StringName = prop.get("class_name", &"")
		var prop_name: StringName = prop.get("name", &"")

		if not _extends(klass_name, &"State"):
			continue
		if prop_name == ignored_property:
			continue
		if is_instance_valid(_owner.get(prop_name)):
			continue

		var identifier: StringName = states_identifiers.get(prop_name, prop_name.to_lower())
		_registry.require(klass_name, [identifier, &""], _owner, prop_name, _on_resolved)

func _on_resolved() -> void:
	state_resolved.emit()

func _get_provided_property_name() -> StringName:
	for child in _owner.get_children():
		if child == self:
			continue
		if child is StateProvider:
			for prop in _owner.get_property_list():
				var klass_name: StringName = prop.get("class_name", &"")
				var prop_name: StringName = prop.get("name", &"")
				if not _extends(klass_name, &"State"):
					continue

				var current = _owner.get(prop_name)
				if current != null or _has_resolvable_constructor(klass_name, _owner):
					return prop_name
			break

	return &""
