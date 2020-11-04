extends Node2D

const DEFAULT_PORT = 31416
const MAX_PEERS    = 10
var DEFAULT_IP="127.0.0.1"
var   players      = {}
var   player_name

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")

func create_server(nombre,puerto):
	player_name=nombre
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(puerto),4)
	get_tree().set_network_peer(peer)
	addJugador(1,nombre)#crear jugador en la clase mundo
	pass


func create_client(nombre,ip,puerto):
	player_name=nombre
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip,int(puerto))
	get_tree().set_network_peer(peer)
	pass

func _connected_ok():
	rpc_id(1, "user_ready", get_tree().get_network_unique_id(), player_name)

remote func user_ready(id, player_name):
	if get_tree().is_network_server():
		rpc_id(id, "register_in_game")
		
remote func register_in_game():
	rpc("register_new_player", get_tree().get_network_unique_id(), player_name)
	register_new_player(get_tree().get_network_unique_id(), player_name)
	
	
remote func register_new_player(id, name):
	if get_tree().is_network_server():
		rpc_id(id, "register_new_player", 1, player_name)
		
		for peer_id in players:
			rpc_id(id, "register_new_player", peer_id, players[peer_id])
			
	players[id] = name
	print(id)
	addJugador(id,name)
	print(players.size())
	

	
func addJugador(id,nombre):
	get_tree().get_root().get_node("Mundo").agregarJugador(id,nombre)
	pass
	
func llamada(camino,funcion,dato):
	rpc("recibeLlamada",camino,funcion,dato)
	pass

func llamada_id(id,camino,funcion,dato):
	rpc_id(id,"recibeLlamada",camino,funcion,dato)
	pass

remote func recibeLlamada(camino,funcion,dato):
	get_tree().get_root().get_node(camino).correrFuncionDelServidor(funcion,dato)
	pass
