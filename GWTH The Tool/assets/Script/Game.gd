extends Node

# Default game server port. Can be any number between 1024 and 49151.
# Not on the list of registered or common ports as of November 2020:
# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const DEFAULT_PORT = 10567

# Max number of players.
const MAX_PEERS = 12

var player_name = "Player"

# Names for remote players in id:name format.
var players = {}
var players_ready = []

#----------------------------------------------------------------


func get_player_list():
	return players.values()

func get_player_name():
	return player_name

func reset_player():
	players = {}
	players_ready = []
