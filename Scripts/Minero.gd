extends Node2D

onready var tex_Amarillo = preload("res://Texturas/fichaAmarillo.png")
onready var tex_Azul = preload("res://Texturas/fichaAzul.png")
onready var tex_Magenta = preload("res://Texturas/fichaMagenta.png")
onready var tex_Rojo = preload("res://Texturas/fichaRojo.png")
onready var tex_Oro = preload("res://Texturas/oro.png")
var habilitado=false
var nroJugador=0
var nroMinero
var tieneOro=false
var mapa
var posx=7
var posy=7
var jugadorActual
var nroPeer
#movimiento con el teclado
#cuando el minero es seleccionado se lo puede manipular y el jugador no puede moverse
# el movimiento de los mineros consume puntos
#dependiendo del jugador, seran los colores de los mineros
func init(n_Jugador,n_Minero,map,jugadorAct,x,y):
	nroJugador=n_Jugador
	nroMinero=n_Minero
	mapa=map
	jugadorActual=jugadorAct
	posx=x
	posy=y
	pass
func setPosX(x):
	posx=x
func setPosY(y):
	posy=y
func setNroPeer(nro):
	nroPeer=nro
func getNroPeer():
	return nroPeer
func setMapa(map):
	mapa=map
func setNroJugador(nro):
	nroJugador=nro
	pass
func setNroMinero(nro):
	nroMinero=nro
func getNroMinero():
	return nroMinero
func habilitar():
	habilitado=true
func desHabilitar():
	habilitado=false
	
func esHabilitado():
	return habilitado
func ponerImagen(nro):
	if nro==1:
		$TextureButton.texture_normal=tex_Amarillo
	elif nro==2:
		$TextureButton.texture_normal=tex_Magenta
	elif nro==3:
		$TextureButton.texture_normal=tex_Azul
	elif nro==4:
		$TextureButton.texture_normal=tex_Rojo
	pass
	
func ponerOro():
	tieneOro=true
	$Sprite.texture=tex_Oro
	pass
func extraeOro():
	if nroPeer == get_tree().get_network_unique_id():
		jugadorActual.agregarOro()
		$ganarOro.play()
		get_tree().get_root().get_node("Mundo").tablaPuntajeLocal()
		Network.llamada("Mundo","tablaPuntaje",{"id":get_tree().get_network_unique_id(),"cantOro":jugadorActual.getCantOro()})#,"idOrigen":get_tree().get_root().get_node("Mundo")
		#avisar a los demas clientes que se ha ganado una unidad de oro
		if jugadorActual.datos.cantOro == 3:
			#condicion de victoria
			Network.llamada("Mundo","cartelVictoria",get_tree().get_network_unique_id())
	pass
func sacarOro():
	tieneOro=false
	$Sprite.texture=null
	pass
	
func verificarSalida(tipo):
	var exito=false
	if tipo=="FichaEntrada":
		exito=true
	return exito
	pass
func setTamanio(num):
	if num == 1:
		$".".scale.x = 0.7
		$".".scale.y = 0.7
	elif num == 2:
		$".".scale.x = 0.5
		$".".scale.y = 0.5
	elif num == 3:
		$".".scale.x = 0.3
		$".".scale.y = 0.3
	elif num == 4:
		$".".scale.x = 0.25
		$".".scale.y = 0.25
	elif num == 5:
		$".".scale.x = 0.25
		$".".scale.y = 0.25
	elif num == 6:
		$".".scale.x = 0.25
		$".".scale.y = 0.25
	elif num == 7:
		$".".scale.x = 0.20
		$".".scale.y = 0.20
	elif num >= 8:
		$".".scale.x = 0.20
		$".".scale.y = 0.20
	pass
func posicion(pos):
	position.x=(posx*64)+(pos.position.x)
	position.y=(posy*64)+(pos.position.y)
	pass
	
func subir():
	#nroJugador,nroMinero,
	return mapa.subirMinero(posx,posy)
	pass
func bajar():
	return mapa.bajarMinero(posx,posy)
	pass
func izquierda():
	return mapa.izquierdaMinero(posx,posy)
	pass
func derecha():
	return mapa.derechaMinero(posx,posy)
		
	pass
func _input(event):
	#se habilita el movimiento cuando es seleccionado
	#en esta seccion se verificaran los puntos del jugador
	#y su consecuente descuento de puntos
	# se da viso a los demas clientes de los movimientos
	if habilitado and jugadorActual.esTurno():
		if event.is_action_pressed("ui_left"):
			if izquierda():
				if jugadorActual.datos.puntos>0:
					posx-=1
					mapa.sacarMinero(self,posx+1,posy)
					mapa.ponerMinero(self,posx,posy)
					Network.llamada("Mundo","moverFichaMinero",{"nroPeer":nroPeer,"nroMinero":nroMinero,"origenX":posx+1,"origenY":posy,"destinoX":posx,"destinoY":posy})
					jugadorActual.datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
			pass
			
		if event.is_action_pressed("ui_right"):
			if derecha():
				if jugadorActual.datos.puntos>0:
					posx+=1
					mapa.sacarMinero(self,posx-1,posy)
					mapa.ponerMinero(self,posx,posy)
					Network.llamada("Mundo","moverFichaMinero",{"nroPeer":nroPeer,"nroMinero":nroMinero,"origenX":posx-1,"origenY":posy,"destinoX":posx,"destinoY":posy})
					jugadorActual.datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
			pass
		if event.is_action_pressed("ui_up"):
			if subir():
				if jugadorActual.datos.puntos>0:
					posy-=1
					mapa.sacarMinero(self,posx,posy+1)
					mapa.ponerMinero(self,posx,posy)
					Network.llamada("Mundo","moverFichaMinero",{"nroPeer":nroPeer,"nroMinero":nroMinero,"origenX":posx,"origenY":posy+1,"destinoX":posx,"destinoY":posy})
					jugadorActual.datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
			pass
		if event.is_action_pressed("ui_down"):
			if bajar():
				if jugadorActual.datos.puntos>0:
					posy+=1
					mapa.sacarMinero(self,posx,posy-1)
					mapa.ponerMinero(self,posx,posy)
					Network.llamada("Mundo","moverFichaMinero",{"nroPeer":nroPeer,"nroMinero":nroMinero,"origenX":posx,"origenY":posy-1,"destinoX":posx,"destinoY":posy})
					jugadorActual.datos.puntos-=1
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
			pass
			
	pass
	
func _on_TextureButton_pressed():
	print("toma ficha minero")
	if nroPeer == get_tree().get_network_unique_id():
		habilitar()
		jugadorActual.desHabilitar()
		jugadorActual.desHabilitarOtrosMineros(nroMinero)
	#envia mensaje al jugador actual, haciendo la verificacion del jugador
	
	#habilita la seleccion para poder mover el minero
	#el jugador es el encargado de verificar la posicion del minero, y el socket de la posicion real y de la verificacion 
	#de una salida
	pass # Replace with function body.
