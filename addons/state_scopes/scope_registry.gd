const ScopeRegistry: Script = preload("res://addons/state_scopes/scope_registry.gd")

static var registries: Array[WeakRef] = []

var _parent_scope: ScopeRegistry
# script_name -> identifier -> weakref(state)
var _state_instances: Dictionary[StringName, Dictionary] = {}
var _pending_states: Array[ScopeRegistryRequest] = []
var _owner: Node

func _init(parent: ScopeRegistry, owner: Node) -> void:
	_parent_scope = parent
	_owner = owner
	registries.push_back(weakref(self))


func require(script: StringName, ids: Array[StringName], \
	consumer: Node, property: StringName, on_resolve: Callable) -> void:
	for id in ids:
		var state := resolve(script, id, consumer)
		if state != null:
			consumer.set(property, state)
			if _fully_resolved(consumer):
				on_resolve.call()
			return
		_pending_states.push_back(ScopeRegistryRequest.new(script, id, \
			consumer, property, on_resolve, false))

func require_by_constructor(script: StringName, consumer: Node, \
	property: StringName, on_resolve: Callable) -> void:
	var state := resolve_constructor(script, consumer)
	if state != null:
		consumer.set(property, state)
		on_resolve.call()
	else:
		_pending_states.push_back(ScopeRegistryRequest.new(script, &"", consumer, \
			property, on_resolve, true))


func provide(script: StringName, id: StringName, state: State) -> void:
	var instances: Dictionary = _state_instances.get_or_add(script, {})
	instances.set(id, weakref(state))
	var generic_instance: WeakRef = instances.get(&"")
	if generic_instance == null or generic_instance.get_ref() == null:
		instances[&""] = weakref(state)

	var resolved_requests: Array[ScopeRegistryRequest] = []
	var expired_requests: Array[ScopeRegistryRequest] = []
	var to_call: Array[Callable] = []
	for request: ScopeRegistryRequest in _pending_states:
		if not is_instance_valid(request.consumer):
			expired_requests.push_back(request)
			continue

		var resolved: State
		if request.use_constructor:
			resolved = resolve_constructor(request.script_name, request.consumer)
		else:
			resolved = resolve(request.script_name, request.identifier, request.consumer)
		if resolved != null and (request.identifier == id or request.identifier == &""):
			if resolved_requests.any(_is_same_target.bind(request)):
				# Already resolved this property
				expired_requests.push_back(request)
			else:
				request.consumer.set(request.property, resolved)
				resolved_requests.push_back(request)
				if request.use_constructor or _fully_resolved(request.consumer):
					to_call.push_back(request.on_resolve)

	for request: ScopeRegistryRequest in expired_requests + resolved_requests:
		_pending_states.erase(request)
	for to in to_call:
		to.call()
	if _parent_scope != null:
		_parent_scope.provide(script, id, state)

func _is_same_target(r1: ScopeRegistryRequest, r2: ScopeRegistryRequest) -> bool:
	return r1.consumer == r2.consumer and r1.property == r2.property

func resolve(script: StringName, id: StringName, consumer: Node) -> State:
	if not StateNode._extends(script, &"State"):
		return null
	var naive_by_identifiers: Dictionary = _state_instances.get_or_add(script, {})
	if naive_by_identifiers != null:
		var state_ref: WeakRef = naive_by_identifiers.get(id)
		if is_instance_valid(state_ref):
			var state = state_ref.get_ref()
			if state != null:
				return state

	var valid_scripts := StateNode._get_derived_classes(script)
	for valid_script in valid_scripts:
		var by_identifiers: Dictionary = _state_instances.get_or_add(valid_script, {})
		if by_identifiers != null:
			var state_ref: WeakRef = by_identifiers.get(id)
			if is_instance_valid(state_ref):
				var state = state_ref.get_ref()
				if state != null:
					return state

	if _parent_scope == null:
		return null
	return _parent_scope.resolve(script, id, consumer)

func resolve_constructor(script: StringName, consumer: Node) -> State:
	var script_instance := _find_script(script)
	assert(script_instance != null)
	if script_instance.has_method(&"create"):
		for method_info in script_instance.get_script_method_list():
			if method_info.get(&"name") == "create":
				var arguments = method_info.get(&"args")
				var arg_script_count: Dictionary[StringName, int] = {}
				for arg in arguments:
					var count := arg_script_count.get_or_add(arg.get(&"class_name"), 0)
					arg_script_count.set(arg.get(&"class_name"), count + 1)
				var resolved_args := []
				for arg in arguments:
					var arg_class: StringName = arg.get(&"class_name")
					if arg_class == &"" or arg_class == "" or arg_class == script:
						return null
					var resolved := resolve(arg_class, arg.get(&"name"), consumer)
					if resolved != null:
						resolved_args.push_back(resolved)
						continue
					if arg_script_count.get(arg_class, 0) < 2:
						resolved = resolve(arg_class, &"", consumer)
						if resolved != null:
							resolved_args.push_back(resolved)
							continue
					var node_script: Script = consumer.get_script()
					if node_script == null:
						continue
					var global_name := node_script.get_global_name()
					if global_name == arg_class:
						resolved_args.push_back(consumer)
				if resolved_args.size() == arguments.size():
					var instance = script_instance.callv(&"create", resolved_args)
					if instance != null:
						return instance
	return null

func _fully_resolved(consumer: Node) -> bool:
	if not is_instance_valid(consumer):
		return false

	for prop in consumer.get_property_list():
		if StateNode._extends(prop.get("class_name"), &"State") \
		and not is_instance_valid(consumer.get(prop.get("name"))):
			return false

	return true

static func _find_script(script: StringName) -> Script:
	for global_class in ProjectSettings.get_global_class_list():
		if global_class.get("class") == script:
			return load(global_class.get("path"))
	return null


class ScopeRegistryRequest:
	var script_name: StringName
	var identifier: StringName
	var consumer: Node
	var property: StringName
	var on_resolve: Callable
	var use_constructor: bool

	func _init(script_name: StringName, identifier: StringName, \
		consumer: Node, prop: StringName, \
		on_resolve: Callable, use_constructor: bool) -> void:

		self.script_name = script_name
		self.identifier = identifier
		self.consumer = consumer
		self.property = prop
		self.on_resolve = on_resolve
		self.use_constructor = use_constructor
