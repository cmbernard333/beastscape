# SignalBus
extends Node

###
## Universal signals that any node can use.
## Useful for avoding coupling.
###

# When the player takes damage; useful for updating UI elements
signal player_take_damage(damage: int)

# For reloading the current floor
signal reload_floor()

# You died
signal game_over()

# Victory Achieved
signal game_win()
