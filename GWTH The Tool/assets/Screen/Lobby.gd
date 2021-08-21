extends Control

onready var PlayPanel : Panel = $PlayPanel

onready var PlayerNameEdit : LineEdit = $PlayPanel/PlayerNameEdit
onready var IPEdit : LineEdit = $PlayPanel/IPEdit
onready var HostBtn : Button = $PlayPanel/HostBtn
onready var JoinBtn : Button = $PlayPanel/JoinBtn

onready var RoomPanel : Panel = $RoomPanel

onready var PlayerList : ItemList = $RoomPanel/PlayerList

onready var Decks_Node = preload("res://assets/Screen/Deck/Decks.tscn")
onready var CreateCards_Node = preload("res://assets/Screen/CreateCard/CreateCard.tscn")

var peer = null

var is_host = false
var is_in_room = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_ok")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	#----
	
	#---

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HostBtn_pressed():
	if PlayerNameEdit.text.empty():
		PopupLayer.CallPopup("Invalid name!")
		return
	
	var new_player_name = PlayerNameEdit.text
	Game.player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(Game.DEFAULT_PORT, Game.MAX_PEERS)
	get_tree().set_network_peer(peer)
	
	is_host = true
	MoveToRoom()

func _on_JoinBtn_pressed():
	if PlayerNameEdit.text.empty():
		PopupLayer.CallPopup("Invalid name!")
		return
	if not IPEdit.text.is_valid_ip_address():
		PopupLayer.CallPopup("Invalid IP address!")
		return
	
	var new_player_name = PlayerNameEdit.text
	var ip = IPEdit.text
	Game.player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, Game.DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	
	joining()

func joining():
	PlayerNameEdit.editable = false
	IPEdit.editable = false
	HostBtn.disabled = true
	JoinBtn.disabled = true

func unjoining():
	PlayerNameEdit.editable = true
	IPEdit.editable = true
	HostBtn.disabled = false
	JoinBtn.disabled = false

func _on_connection_failed():
	PopupLayer.CallPopup("Connection failed.")
	unjoining()

func _on_connected_ok():
	MoveToRoom()

func _on_server_disconnected():
	PopupLayer.CallPopup("Server disconnected")
	
	
func _player_connected(id):
	rpc_id(id, "register_player", Game.player_name)

func _player_disconnected(id):
	if is_in_room:
		var chat = "** %s ได้ออกจากห้องไปแล้ว **" % Game.players[id]
		Chat.enter_new_chat(chat, 2)
		unregister_player(id)
	#if has_node("/root/World"): # Game is in progress.
	#	if get_tree().is_network_server():
	#		emit_signal("game_error", "Player " + players[id] + " disconnected")
	#		end_game()
	#else: # Game is not in progress.
		# Unregister this player.
	#	unregister_player(id)

remote func register_player(new_player_name):
	var id = get_tree().get_rpc_sender_id()
	print(id)
	Game.players[id] = new_player_name
	SoundControl.se_play_bell()
	player_list_changed()
	var chat : String
	if id == 1:
		chat = "** ยินดีต้อนรับสู่ห้องของ %s **" % new_player_name
	else:
		chat = "** %s ได้เข้ามาในห้องแล้ว **" % new_player_name
	Chat.enter_new_chat(chat, 1)

func unregister_player(id):
	Game.players.erase(id)
	player_list_changed()

remote func host_disconnected():
	PopupLayer.CallPopup("Host disconnected")
	MoveToLobby()

func MoveToRoom():
	SoundControl.se_play_bell()
	RoomPanel.show()
	PlayPanel.hide()
	refresh_lobby()
	Chat.ShowChat()
	is_in_room = true

func MoveToLobby():
	RoomPanel.hide()
	PlayPanel.show()
	is_host = false
	is_in_room = false
	Game.reset_player()
	get_tree().set_network_peer(null)
	unjoining()
	Chat.HideChat()

#--------------------------------------------------------------------------

func player_list_changed():
	refresh_lobby()

func refresh_lobby():
	var players = Game.get_player_list()
	players.sort()
	PlayerList.clear()
	PlayerList.add_item(Game.get_player_name() + " (You)")
	for p in players:
		PlayerList.add_item(p)
	#$Players/Start.disabled = not get_tree().is_network_server()

func _on_LeaveBtn_pressed():
	if is_host:
		rpc("host_disconnected")
	get_tree().get_network_peer().close_connection()
	MoveToLobby()

func _on_ReadyCheckBox_pressed():
	pass # Replace with function body.


func _on_ModsButton_pressed():
	#var mods = load("res://assets/Screen/Mods.tscn").instance()
	#get_tree().get_root().add_child(mods)
	#get_tree().get_root().find_node("Mods", true, false).show()
	Mods.show()
	Mods.hide_help_ui()
	hide()

func _on_DecksBtn_pressed():
	var decks = Decks_Node.instance()
	get_tree().get_root().add_child(decks)
	hide()

func _on_CreateCardsBtn_pressed():
	var create_card = CreateCards_Node.instance()
	get_tree().get_root().add_child(create_card)
	hide()
