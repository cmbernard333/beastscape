class_name StatesStore extends RefCounted

###
## StatesStore as a unified store for the current state of the connected StatesManagers
## e.g. StatesStore.store['movements_states_manager'] will return current state of the movements_states_manager
###

var store: Dictionary = {}:
	get: return store.duplicate()
	set(value): return
	
func register_state_manager(state_manager: StatesManager):
	state_manager.state_changed.connect(_on_state_machinestate_changed)

func _on_state_machinestate_changed(
	previous_state_name: String, 
	next_state_name: String, 
	state_manager_name: String):
		store[state_manager_name] = next_state_name

func _init(states_managers: Array[StatesManager] = []):
	for state_manager: StatesManager in states_managers:
		register_state_manager(state_manager)
