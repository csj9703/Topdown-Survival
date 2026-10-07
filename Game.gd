extends Node2D
@onready var multiplayer_menu_UI = $UI/Multiplayer

const PLAYER = preload("res://Player.tscn")

var peer = ENetMultiplayerPeer.new()
var ip_address = ""

func _on_peer_disconnected(pid: int) -> void:
	print("Peer disconnected: ", pid)

	var player = get_node_or_null(str(pid))
	if player:
		player.queue_free()

func _on_server_disconnected() -> void:
	print("Server disconnected")
	disconnect_from_game()

func _on_connection_failed() -> void:
	print("Connection failed")
	disconnect_from_game()

func disconnect_from_game() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_host_pressed() -> void:
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			add_player(pid)
	)
	add_player(multiplayer.get_unique_id())
	multiplayer_menu_UI.hide()

func _on_join_pressed() -> void:
	peer.create_client(ip_address, 25565)
	multiplayer.multiplayer_peer = peer
	multiplayer_menu_UI.hide()

func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	add_child(player)

func _on_line_edit_text_submitted(new_text: String) -> void:
	ip_address = new_text
