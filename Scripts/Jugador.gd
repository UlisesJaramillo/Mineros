extends Node2D

# el jugador tiene que  tener una referencia al socket actual
# tiene la responsabilidad de tener a los tres mineros y poder moverlos
#tiene que tener una referencia a su mano, para poder extraer una ficha.
#tiene que tener una referencia a la bolsa para sacar fichas y ponerlas en la mano.
#turnoActual


#METODOS:
#sacarFichaBolsa():String
#sacarFichaMano():String
#ponerFicha(String,Socket):boolean indica que tiene que crear en la ficha que está seleccionando, por default es la ultima en construir
#actualizar():void actualiza el socket actual, para poder resaltar los sockets habilitados a construir.

#//////////////////////////////////////////////
#VARIABLES
var datos = {"nombre":"","id":0,"cantOro":0,"puntos":0}
var esTurno=false
var mineros = []
var mapa
var posx=7
var posy=7
var habilitado=true
var dadoHabilitado=false
var esSeleccionado=false
onready var minero = preload("res://Minero.tscn")
var nroJugador
#////////////////////////////////////////////////
#METODOS


func _process(delta):
	
	pass
func habilitar():
	habilitado=true
func desHabilitar():
	habilitado=false
func crearMineros():
	var instancia
	for i in range(3):
		instancia = minero.instance()
		mineros.append(instancia)
		instancia.init(nroJugador,i,mapa,self,posx,posy)
		get_tree().get_root().get_node("Mundo").add_child(instancia)
		instancia.ponerImagen(nroJugador)
		mapa.ponerMinero(instancia,7,7)
		#Network.llamada("Mundo","ponerFichaMinero",{"nro":nroJugador,"posx":7,"posy":7,"nroMinero":i})
		#avisar a los demas jugadores para que coloque fichas de los mineros
		#solicitar a los demas clientes sus mineros para colocarlos en el mapa
	Network.llamada("Mundo","solicitarFichasMinero",get_tree().get_network_unique_id())
func setNroJugador(nro):
	nroJugador=nro
func getNroJugador():
	return nroJugador
func setPuntos(nro):
	datos.puntos=nro
func getPosicion():
	return {"x":posx,"y":posy}
func seleccionar():
	esSeleccionado=true
	pass
func _input(event):
	if esTurno:
		if habilitado:
			if event.is_action_pressed("ui_left"):
				print("moverr11")
				if datos.puntos>0:
					print("moverr")
					mapa.quitarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","quitarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					var exito = izquierda()
					mapa.agregarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","agregarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					if exito:
						datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
				pass
			if event.is_action_pressed("ui_right"):
				if datos.puntos>0:
					mapa.quitarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","quitarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					var exito = derecha()
					mapa.agregarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","agregarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					if exito:
						datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
			if event.is_action_pressed("ui_up"):
				if datos.puntos>0:
					mapa.quitarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","quitarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					var exito = subir()
					mapa.agregarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","agregarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					if exito:
						datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
			if event.is_action_pressed("ui_down"):
				if datos.puntos>0:
					mapa.quitarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","quitarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					var exito = bajar()
					mapa.agregarJugador(posx,posy,get_tree().get_network_unique_id())
					Network.llamada("Mundo","agregarJugador",{"x":posx,"y":posy,"id":get_tree().get_network_unique_id()})
					if exito:
						datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
		
		pass

func init(nom,map,id,n_jugador):
	#recibe el nombre del jugador, y es socket en el que se situa.
	datos.nombre=nom
	nroJugador=n_jugador
	mapa=map
	datos.id=id
	posicionar()
	$Imagen.hide()
	mapa.desResaltar(posx,posy)
	
	pass
	
func asignarColorMineros(nro):
	for i in range(3):
		mineros[i].ponerImagen(nro)
	pass
func setNroJugadorMineros(nro):
	for i in range(3):
		mineros[i].setNroJugador(nro)
func agregarMinero(minero):
	mineros.append(minero)
	pass
	
func agregarOro():
	datos.cantOro +=1
	pass
	
func getCantOro():
	return datos.cantOro
	pass
	
func esTurno():
	return esTurno
	pass
	
func setTurno(turno):
	esTurno=turno
	pass
func getCantidadFichas():
	return $Mano.getCantFichas()
func getMano():
	#devuelve una coleccion con las cantidades de cada ficha
	return $Mano.getMano()
	pass
func ponerFicha(ficha):
	$Mano.ponerFicha(ficha)
	pass
	
func sacarFicha(ficha):
	$Mano.sacarFicha(ficha)
	print($Mano.getCantFichas())
	
func posicionar():
	var pos = mapa.posicion(posx,posy)
	position.x=pos.x
	position.y=pos.y
	mapa.resaltar(posx,posy)
	
func subir():
	var exito=false
	if mapa.subir(posx,posy):
		mapa.desResaltar(posx,posy)
		posy-=1
		posicionar()
		exito=true
		pass
	return exito
	
func bajar():
	var exito=false
	if mapa.bajar(posx,posy):
		mapa.desResaltar(posx,posy)
		posy+=1
		posicionar()
		exito=true
	return exito
	
func izquierda():
	var exito=false
	if mapa.izquierda(posx,posy):
		mapa.desResaltar(posx,posy)
		posx-=1
		posicionar()
		exito=true
	return exito
	
func derecha():
	var exito=false
	if mapa.derecha(posx,posy):
		mapa.desResaltar(posx,posy)
		posx+=1
		posicionar()
		exito=true
	return exito
func empezarTurno():
	dadoHabilitado=true
	esTurno=true
	$Imagen.show()
	mapa.resaltar(posx,posy)
	
func finTurno():
	print("terminar Turno")
	mapa.desResaltar(posx,posy)
	$Imagen.hide()
	esTurno=false
	datos.puntos=0
	
func setPosicion(x,y):
	posx=x
	posy=y
	posicionar()
	pass
func desHabilitarOtrosMineros(nroMinero):
	for i in range(3):
		if i != nroMinero:
			mineros[i].desHabilitar()
	pass
func setNroPeerMineros(nro):
	for i in range(3):
		mineros[i].setNroPeer(nro)
	pass
func _on_TextureButton_pressed():
	habilitar()
	for i in range(3):
		mineros[i].desHabilitar()
	
	pass # Replace with function body.
