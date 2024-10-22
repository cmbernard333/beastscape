class_name StatesStore extends RefCounted

enum StatesStoreKey {
	PLAYER_SPEED=0x80000000, 
	PLAYER_JUMP_START
}

###
## StatesStore as a unified store for the current state of the connected StatesManagers
## e.g. StatesStore.store['movements_states_manager'] will return current state of the movements_states_manager
###

var _store: Dictionary = {}

func get_store_key(statesStoreKey: StatesStoreKey) -> Variant:
	return _store[statesStoreKey]

func set_store_key(statesStoreKey: StatesStoreKey, object: Variant):
	_store[statesStoreKey] = object
	
func register_state_manager(state_manager: StatesManager):
	state_manager.state_changed.connect(_on_state_machinestate_changed)

func _on_state_machinestate_changed(
	previous_state_name: String, 
	next_state_name: String, 
	state_manager_name: String):
		_store[state_manager_name] = next_state_name

func _init(states_managers: Array[StatesManager] = []):
	for state_manager: StatesManager in states_managers:
		register_state_manager(state_manager)
