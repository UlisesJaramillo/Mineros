extends Node2D

onready var socket = preload("res://Escenas/Socket.tscn")
var mapa = []
var desplX = 64
var desplY = 64

func _ready():
	crearMapa()
	mapa[7][7].construir("FichaEntrada",0)
	mapa[0][7].construir("FichaOro",0)
	mapa[7][0].construir("FichaOro",0)
	mapa[14][7].construir("FichaOro",0)
	mapa[7][14].construir("FichaOro",0)
	
	pass
	
func init():
	pass
	
func subirMinero(x,y):#retorna booleano si es posible el movimiento
	return mapa[x][y].subir()
	pass
func agregarJugador(x,y,id):
	#se avisa a los demas clientes de la modificacion
	mapa[x][y].agregarJugador(id)
	
func quitarJugador(x,y,id):
	
	mapa[x][y].quitarJugador(id)
func bajarMinero(x,y):
	return mapa[x][y].bajar()
	pass
	
func derechaMinero(x,y):
	return mapa[x][y].derecha()
	pass
	
func izquierdaMinero(x,y):
	return mapa[x][y].izquierda()
	pass
func sacarMinero(minero,posx,posy):
	mapa[posx][posy].sacarMinero(minero)
	pass
func actualizarMineros(posx,posy):
	mapa[posx][posy].actualizarCantMineros()
func ponerMinero(minero,posx,posy):
	mapa[posx][posy].ponerMinero(minero)
	pass
func buscarMinero(nroPeer,nroMinero,x,y):
	return mapa[x][y].buscarMinero(nroPeer,nroMinero)
func crearMapa():
	#metodo que crea el mapa con todas las fichas relacionadas entre si
	#es un mapa o tablero de 15 x 15 fichas 
	for x in range(15):#creacion de un arrelo bidimencional (arreglo de arreglos)
		mapa.append([])
		mapa[x].resize(15)
		for y in range(15):
			mapa[x][y] = 0
	for i in range(15):
		for j in range(15):
			var instancia = socket.instance()
			instancia.init(j*desplX,i*desplY)
			mapa[j][i]=instancia#inverti las letras i y j para adecuar la concexion con los vecinos
			add_child(instancia)
			mapa[j][i].construir("FichaTierra",0)
			
	for i in range(15):
		for j in range(15):
			if i< 14:
				mapa[i][j].setAdyDerecha(mapa[i+1][j])
			if i >0:
				mapa[i][j].setAdyIzquierda(mapa[i-1][j])
			if j < 14 :
				mapa[i][j].setAdyAbajo(mapa[i][j+1])
			if j>0:
				mapa[i][j].setAdyArriba(mapa[i][j-1])
	pass

func construir(ficha,rotacion,x,y):
	mapa[x][y].construir(ficha,rotacion)
	pass
func destruir(x,y):
	mapa[x][y].destruir()
	
func subir(x,y):
	return mapa[x][y].subir()
	pass
func bajar(x,y):
	return mapa[x][y].bajar()
	pass
func derecha(x,y):
	return mapa[x][y].derecha()
	pass
func izquierda(x,y):
	return mapa[x][y].izquierda()
	pass
	
func posicion(x,y):
	return mapa[x][y].posicion()
	pass

func resaltar(x,y):
	#resalta las 4 casillas que estan alrededor
	if x !=0:
		mapa[x-1][y].resaltar()
	if x != 14:
		mapa[x+1][y].resaltar()
	if y != 0:
		mapa[x][y-1].resaltar()
	if y != 14:
		mapa[x][y+1].resaltar()
	pass
	
func desResaltar(x,y):
	if x !=0:
		mapa[x-1][y].desResaltar()
	if x != 14:
		mapa[x+1][y].desResaltar()
	if y != 0:
		mapa[x][y-1].desResaltar()
	if y != 14:
		mapa[x][y+1].desResaltar()
	pass
	
func obtenerPosicionSocket(posx,posy):
	var x
	var y
	if posx!=0:
		x = posx/desplX
	else:
		x = 0
	if posy!=0:
		y = posy/desplY
	else:
		y=0
	return {"x":x,"y":y}
	pass
