class_name StateMachine extends Node

@export var initial_state: State
var states: Dictionary
var current_state: State
var current_state_name: String:
	get():
		return states.find_key(current_state)

func _ready() -> void:
	states = {}
	for child in get_children():
		if (!child is State):
			continue

		states[child.name.to_lower()] = child
		child.transitioned.connect(_on_child_transition)
	
	if (initial_state):
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if (current_state && current_state.can_update):
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if (current_state && current_state.can_physics_update):
		current_state.physics_update(delta)

func _on_child_transition(state: State, new_state_name: String):
	if (state != current_state):
		return

	change_state(new_state_name.to_lower())

func change_state(state_name: String):
	var new_state: State = states.get(state_name.to_lower())
	if (!new_state):
		printerr("Tentando transicionar para estado não existete: ", state_name)
		return

	if (current_state):
		current_state.exit()
	
	current_state = new_state
	new_state.enter()

func register_state(state: State, state_name: String):
	if (state):
		states[state_name.to_lower()] = state
		state.transitioned.connect(_on_child_transition)

func remove_state(state_name: String):
	var state: State = states[state_name.to_lower()]
	if (states.erase(state_name.to_lower())):
		state.transitioned.disconnect(_on_child_transition)
	
