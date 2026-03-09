class_name StateDebugView
extends Control

const ScopeRegistry: Script = preload("res://addons/state_scopes/scope_registry.gd")

@export var refresh_interval := 0.5

@export var show_empty := false

var _refresh_timer: Timer
var _tree: Tree
var _status_label: Label

func _ready() -> void:
	_build_ui()
	_refresh()

func _build_ui() -> void:
	set_anchors_and_offsets_preset(PRESET_FULL_RECT)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	add_child(root)

	var title_bar := HBoxContainer.new()
	title_bar.set_anchors_and_offsets_preset(PRESET_TOP_WIDE)
	title_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_child(title_bar)

	var title := Label.new()
	title.text = "State Debug View"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title_bar.add_child(title)

	_status_label = Label.new()
	_status_label.text = "Loading..."
	_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_bar.add_child(_status_label)

	var toggle_empty_button := Button.new()
	toggle_empty_button.text = "Toggle empty"
	toggle_empty_button.pressed.connect(func() -> void:
		show_empty = not show_empty
		_refresh())
	title_bar.add_child(toggle_empty_button)

	var refresh_button := Button.new()
	refresh_button.text = "Refresh"
	refresh_button.pressed.connect(_refresh)
	title_bar.add_child(refresh_button)

	_tree = Tree.new()
	_tree.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_tree.columns = 2
	_tree.hide_root = true
	_tree.set_column_title(0, "Item")
	_tree.set_column_title(1, "Details")
	_tree.column_titles_visible = true
	root.add_child(_tree)

func _refresh() -> void:
	if not visible:
		return

	_tree.clear()
	var root := _tree.create_item()
	var registries := _get_live_registries()
	_status_label.text = "Live registries: {0}".format([registries.size()])

	for registry in registries:
		_add_registry_item(root, registry)

func _get_live_registries() -> Array[ScopeRegistry]:
	var result: Array[ScopeRegistry] = []

	for registry_ref in ScopeRegistry.registries:
		if registry_ref == null:
			continue
		var registry = registry_ref.get_ref()
		if registry == null:
			continue
		result.push_back(registry)

	return result

func _add_registry_item(parent: TreeItem, registry: ScopeRegistry) -> void:
	var item := _tree.create_item(parent)
	item.set_text(0, "Registry")
	item.set_text(1, "owner={owner}, parent={parent}".format({
		owner = _format_value(registry._owner),
		parent = "null" if registry._parent_scope == null
			else _format_value(registry._parent_scope._owner)
	}))

	var states_item := _tree.create_item(item)
	states_item.set_text(0, "States")
	states_item.set_text(1, "{0} classes".format([registry._state_instances.size()]))

	for script_name in registry._state_instances.keys():
		_add_script_states_item(states_item, script_name, registry._state_instances[script_name])

	var pending_item := _tree.create_item(item)
	pending_item.set_text(0, "Pending")
	pending_item.set_text(1, "{0} pendings (bad if non-zero)" \
		.format([registry._pending_states.size()]))

	for request in registry._pending_states:
		var request_item := _tree.create_item(pending_item)
		request_item.set_text(0, "{consumer}.{property}".format({
			consumer = _format_value(request.consumer),
			property = request.property
		}))
		request_item.set_text(1, "state={state}, id={id}, constructor={constructor}".format({
			state = request.script_name,
			id = request.identifier,
			constructor = str(request.use_constructor)
		}))

func _add_script_states_item(parent: TreeItem, script_name: StringName,
	by_identifier: Dictionary) -> void:
	var script_item := _tree.create_item(parent)
	script_item.set_text(0, str(script_name))
	script_item.set_text(1, "{0} identifiers ({1} empty)".format(
		[by_identifier.size(), by_identifier.keys().count(&"")]))

	for identifier in by_identifier.keys():
		if not show_empty and identifier == &"":
			continue
		var state_ref = by_identifier[identifier]
		var state = state_ref.get_ref() if state_ref != null else null

		var state_item := _tree.create_item(script_item)
		state_item.set_text(0, identifier)
		state_item.set_text(1, _format_value(state))

		if state != null:
			_add_state_properties(state_item, state)

func _add_state_properties(parent: TreeItem, state: State) -> void:
	for prop in state.get_property_list():
		var prop_name: StringName = prop.get("name", &"")
		var usage: int = prop.get("usage", 0)

		if prop_name == &"":
			continue
		if not (usage & PROPERTY_USAGE_SCRIPT_VARIABLE):
			continue

		var value = state.get(prop_name)
		var item := _tree.create_item(parent)
		item.set_text(0, String(prop_name))
		item.set_text(1, _format_value(value))

		if value is Object and value != null and value is not Script:
			_add_object_properties(item, value, 1)

func _add_object_properties(parent: TreeItem, object: Object, depth: int) -> void:
	if depth > 4:
		return

	for prop in object.get_property_list():
		var prop_name: StringName = prop.get("name", &"")
		var usage: int = prop.get("usage", 0)

		if prop_name == &"":
			continue
		if not (usage & PROPERTY_USAGE_SCRIPT_VARIABLE):
			continue

		var value = object.get(prop_name)
		var item := _tree.create_item(parent)
		item.set_text(0, String(prop_name))
		item.set_text(1, _format_value(value))

		if value is Object and value != null and not (value is Script):
			_add_object_properties(item, value, depth + 1)

func _format_value(value: Variant) -> String:
	if value == null:
		return "null"
	if value is String or value is StringName:
		return "\"{0}\"".format([value])
	if value is Node:
		return "{0} ({1})".format([value.name, value.get_class()])
	if value is Object:
		return "{0} @{1}".format([value.get_class(), str(value.get_instance_id())])
	if value is Array or value is Dictionary:
		return JSON.stringify(value)
	return str(value)
