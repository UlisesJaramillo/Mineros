extends Node2D

#usa un Sprite transparente, con borde de algún color en estado normal
#usa un Sprite de color para indicar si se puede construir sobre el Socket
#usa un Sprite de color rojo para indicar que el socket no esta disponible para la construccion, puede ser el caso de destruccion o no conectado.
#posee una referencia a cuatro sockets adyacentes llamados: arriba, abajo, izquierda, derecha.
#tiene la responsabilidad de crear una ficha o cambiarla. y luego notificar a los sockets adyacentes.
#


#METODOS
#crearFicha(String):boolean crea una ficha del tipo deseado.
#actualizar():void    #actualiza las conexiones con los sockets adyacentes pendiendo de la ficha que posea.
#destruir():boolean		si la ficha esta habilitada para destruir, lo hace y cambia la ficha a una destruida.
#obtenerTipoFicha:String    devuelve el nombre de la ficha que tiene dentro, si no tiene  ninguna ficha devuelve "vacío".


#////////////////////////////////////////////////////////////
#VARIABLES

var adyArriba
var adyAbajo
var adyIzquierda
var adyDerecha
var habilitado=false
var destruido=false
var disponibleConstruccion=false
var construido = false
var tipoFicha#nombre de la ficha actual
var mineros=[]
var caminoArriba=false
var caminoAbajo=false			#tiene en cuenta si estan disponibles los caminos para poder moverse o construir
var caminoIzquierda=false
var caminoDerecha=false
var jugadores =[]
#////////////////////////////////////////////////////
#ESCENAS

#//////////////////////////////////////////////////////////////
#TEXTURAS
onready var tex_I = preload("res://Texturas/fichaI.png")
onready var tex_L = preload("res://Texturas/fichaL.png")
onready var tex_T = preload("res://Texturas/fichaT.png")
onready var tex_Cruz = preload("res://Texturas/fichaCruz.png")
onready var tex_Tierra = preload("res://Texturas/fichaTierra.png")
onready var tex_Tierra2 = preload("res://Texturas/fichaTierra2.png")
onready var tex_Oro = preload("res://Texturas/fichaOro.png")
onready var tex_Entrada = preload("res://Texturas/fichaEntrada.png")
onready var tex_Construir = preload("res://Texturas/construir.png")
onready var tex_Habilitado = preload("res://Texturas/habilitado.png")
onready var tex_Prohibido = preload("res://Texturas/prohibido.png")
#////////////////////////////////////////////////////////////
#METODOS


func init(X,Y):
	position.x=X
	position.y=Y
	ponerFicha("FichaTierra",0)
	pass
func agregarJugador(id):
	if !jugadores.has(id):
		jugadores.append(id)
func quitarJugador(id):
	if jugadores.has(id):
		print("borrado"+str(id))
		jugadores.erase(id)
func ponerFicha(tipo,rotacion):
	#metodo para colocar una ficha en el socket, basicamente carga la textura y la coloca en el texture button
	#tiene en cuenta la rotacion de la imagen, para poder habilitar los caminos correspondientes
	
	if tipo == "FichaI":
		$Imagen.texture = tex_I
		$Imagen.rotation_degrees=rotacion
		tipoFicha = "FichaI"
		$ponerFicha.play()
		if rotacion == 0 or rotacion == 180:
			caminoArriba=false
			caminoAbajo=false
			caminoIzquierda=true
			caminoDerecha=true
		else:
			caminoArriba=true
			caminoAbajo=true
			caminoIzquierda=false
			caminoDerecha=false
	elif tipo =="FichaL":
		$ponerFicha.play()
		$Imagen.texture = tex_L
		$Imagen.rotation_degrees=rotacion
		tipoFicha = "FichaL"
		if rotacion==0:
			caminoArriba=false
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=true
		elif rotacion == 90:
			caminoArriba=false
			caminoDerecha=false
			caminoIzquierda=true
			caminoAbajo=true
		elif rotacion == 180:
			caminoArriba=true
			caminoDerecha=false
			caminoIzquierda=true
			caminoAbajo=false
		elif rotacion == 270:
			caminoArriba=true
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=false
	elif tipo == "FichaT":
		$ponerFicha.play()
		$Imagen.texture = tex_T
		$Imagen.rotation_degrees=rotacion
		tipoFicha = "FichaT"
		if rotacion==0:
			caminoArriba=false
			caminoDerecha=true
			caminoIzquierda=true
			caminoAbajo=true
		elif rotacion == 90:
			caminoArriba=true
			caminoDerecha=false
			caminoIzquierda=true
			caminoAbajo=true
		elif rotacion == 180:
			caminoArriba=true
			caminoDerecha=true
			caminoIzquierda=true
			caminoAbajo=false
		elif rotacion == 270:
			caminoArriba=true
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=true
	elif tipo == "FichaCruz":
		$ponerFicha.play()
		$Imagen.texture = tex_Cruz
		$Imagen.rotation_degrees=rotacion
		tipoFicha = "FichaCruz"
		caminoArriba=true
		caminoDerecha=true
		caminoIzquierda=true
		caminoAbajo=true
	elif tipo == "FichaTierra":
		tipoFicha = "FichaTierra"
		$Imagen.texture = tex_Tierra
		$Imagen.rotation_degrees=rotacion
		caminoArriba=false
		caminoDerecha=false
		caminoIzquierda=false
		caminoAbajo=false
	elif tipo == "FichaTierra2":
		$explosion.play()
		tipoFicha = "FichaTierra2"
		$Imagen.texture = tex_Tierra2
		$Imagen.rotation_degrees=rotacion
		caminoArriba=false
		caminoDerecha=false
		caminoIzquierda=false
		caminoAbajo=false
	elif tipo == "FichaOro":
		tipoFicha = "FichaOro"
		$Imagen.texture = tex_Oro
		$Imagen.rotation_degrees=rotacion
		caminoArriba=true
		caminoDerecha=true
		caminoIzquierda=true
		caminoAbajo=true
	elif tipo == "FichaEntrada":
		$ponerFicha.play()
		tipoFicha = "FichaEntrada"
		$Imagen.texture = tex_Entrada
		$Imagen.rotation_degrees=rotacion
		caminoArriba=true
		caminoDerecha=true
		caminoIzquierda=true
		caminoAbajo=true
	
	pass
	
func construir(tipo,rotacion):
	if !destruido:
		if tipo == "FichaTierra":
			habilitado=true
		else:
			habilitado=true
			construido=true
		ponerFicha(tipo,rotacion)
		
		actualizar()
	
	pass
	
func getCaminoArriba():
	return caminoArriba
	
func getCaminoAbajo():
	return caminoAbajo
	
func getCaminoIzquierda():
	return caminoIzquierda
	
func getCaminoDerecha():
	return caminoDerecha
	
func setAdyArriba(socket):
	adyArriba=socket
	pass
	
func setAdyAbajo(socket):
	adyAbajo=socket
	pass
func setAdyDerecha(socket):
	adyDerecha=socket
	pass
func setAdyIzquierda(socket):
	adyIzquierda=socket
	pass
func getAdyArriba():
	return adyArriba
	pass
	
func getAdyAbajo():
	return adyAbajo
	pass
func getAdyDerecha():
	return adyDerecha
	pass
func getAdyIzquierda():
	return adyIzquierda
	pass
	
	
func destruir():
	if mineros.size()==0:
		ponerFicha("FichaTierra2",0)
		destruido=true
		habilitado=false
		if getAdyArriba().getCaminoAbajo():
			if getAdyArriba().getTipo()=="FichaT":
				if !getAdyArriba().getCaminoArriba():
					getAdyArriba().ponerFicha("FichaI",0)
				elif !getAdyArriba().getCaminoDerecha():
					getAdyArriba().ponerFicha("FichaL",180)
				elif !getAdyArriba().getCaminoIzquierda():
					getAdyArriba().ponerFicha("FichaL",270)
			elif getAdyArriba().getTipo()=="FichaCruz":
				getAdyArriba().ponerFicha("FichaT",180)
		if getAdyAbajo().getCaminoArriba():
			if getAdyAbajo().getTipo()=="FichaT":
				if !getAdyAbajo().getCaminoAbajo():
					getAdyAbajo().ponerFicha("FichaI",0)
				elif !getAdyAbajo().getCaminoDerecha():
					getAdyAbajo().ponerFicha("FichaL",90)
				elif !getAdyAbajo().getCaminoIzquierda():
					getAdyAbajo().ponerFicha("FichaL",270)
			elif getAdyAbajo().getTipo()=="FichaCruz":
				getAdyAbajo().ponerFicha("FichaT",0)
				
		if getAdyDerecha().getCaminoIzquierda():
			if getAdyDerecha().getTipo()=="FichaT":
				if !getAdyDerecha().getCaminoDerecha():
					getAdyDerecha().ponerFicha("FichaI",90)
				if !getAdyDerecha().getCaminoAbajo():
					getAdyDerecha().ponerFicha("FichaL",270)
				if !getAdyDerecha().getCaminoArriba():
					getAdyDerecha().ponerFicha("FichaL",0)
			elif getAdyDerecha().getTipo()=="FichaCruz":
				getAdyDerecha().ponerFicha("FichaT",270)
		if getAdyIzquierda().getCaminoDerecha():
			if getAdyIzquierda().getTipo()=="FichaT":
				if !getAdyIzquierda().getCaminoIzquierda():
					getAdyIzquierda().ponerFicha("FichaI",90)
				if !getAdyIzquierda().getCaminoAbajo():
					getAdyIzquierda().ponerFicha("FichaL",180)
				if !getAdyIzquierda().getCaminoArriba():
					getAdyIzquierda().ponerFicha("FichaL",90)
			elif getAdyIzquierda().getTipo()=="FichaCruz":
				getAdyIzquierda().ponerFicha("FichaT",90)
	pass
	
func actualizar():
	#modifica a los sockets vecinos para que respeten las conexiones
	if getCaminoArriba():
		if getAdyArriba()!=null and !getAdyArriba().getCaminoAbajo():
			if getAdyArriba().getTipo()=="FichaI":
				getAdyArriba().ponerFicha("FichaT",0)
			elif getAdyArriba().getTipo()=="FichaL":
				if getAdyArriba().getCaminoDerecha():
					getAdyArriba().ponerFicha("FichaT",270)
				else:
					getAdyArriba().ponerFicha("FichaT",90)
			elif getAdyArriba().getTipo()=="FichaT":
				getAdyArriba().ponerFicha("FichaCruz",0)
	if getCaminoAbajo():
		if getAdyAbajo()!=null and !getAdyAbajo().getCaminoArriba():
			print("Llego")
			if getAdyAbajo().getTipo()=="FichaI":
				print("LlegoI")
				getAdyAbajo().ponerFicha("FichaT",180)
			elif getAdyAbajo().getTipo()=="FichaL":
				print("LlegoL")
				if getAdyAbajo().getCaminoDerecha():
					getAdyAbajo().ponerFicha("FichaT",270)
				else:
					getAdyAbajo().ponerFicha("FichaT",90)
			elif getAdyAbajo().getTipo()=="FichaT":
				print("Llego!!!!!!!!")
				getAdyAbajo().ponerFicha("FichaCruz",0)
	if getCaminoDerecha():
		if getAdyDerecha()!=null and !getAdyDerecha().getCaminoIzquierda():
			if getAdyDerecha().getTipo()=="FichaI":
				getAdyDerecha().ponerFicha("FichaT",90)
			elif getAdyDerecha().getTipo()=="FichaL":
				if getAdyDerecha().getCaminoArriba():
					getAdyDerecha().ponerFicha("FichaT",180)
				else:
					getAdyDerecha().ponerFicha("FichaT",0)
			elif getAdyDerecha().getTipo()=="FichaT":
				getAdyDerecha().ponerFicha("FichaCruz",0)
	if getCaminoIzquierda():
		if getAdyIzquierda()!=null and !getAdyIzquierda().getCaminoDerecha():
			if getAdyIzquierda().getTipo()=="FichaI":
				getAdyIzquierda().ponerFicha("FichaT",270)
			elif getAdyIzquierda().getTipo()=="FichaL":
				if getAdyIzquierda().getCaminoArriba():
					getAdyIzquierda().ponerFicha("FichaT",180)
				else:
					getAdyIzquierda().ponerFicha("FichaT",0)
			elif getAdyIzquierda().getTipo()=="FichaT":
				getAdyIzquierda().ponerFicha("FichaCruz",0)
			
	pass
	
func getTipo():
	#retorna un string con el nombre del tipo de ficha actual, en caso de que no halla ficha devuelve "vacio"
	return tipoFicha
	pass
	
func girar():
	#gira la ficha 90 grados hacia la derecha
	#tiene en cuenta solo una revolucion
	$Imagen.rotation_degrees = ($Imagen.rotation_degrees +90)%360
	if tipoFicha == "FichaI":
		if $Imagen.rotation_degrees ==90 or $Imagen.rotation_degrees ==270 :
			caminoArriba=true
			caminoAbajo=true
			caminoIzquierda=false
			caminoDerecha=false
		else:
			caminoArriba=false
			caminoAbajo=false
			caminoIzquierda=true
			caminoDerecha=true
	elif tipoFicha == "FichaL":
		if $Imagen.rotation_degrees ==0:
			caminoArriba=false
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=true
		elif $Imagen.rotation_degrees ==90:
			caminoArriba=false
			caminoDerecha=false
			caminoIzquierda=true
			caminoAbajo=true
		elif $Imagen.rotation_degrees ==180:
			caminoArriba=true
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=false
		elif $Imagen.rotation_degrees ==270:
			caminoArriba=true
			caminoDerecha=false
			caminoIzquierda=true
			caminoAbajo=false
	elif tipoFicha == "FichaT":
		if $Imagen.rotation_degrees ==0:
			caminoArriba=false
			caminoIzquierda=true
			caminoDerecha=true
			caminoAbajo=true
		elif $Imagen.rotation_degrees ==90:
			caminoArriba=true
			caminoDerecha=false
			caminoIzquierda=true
			caminoAbajo=true
		elif $Imagen.rotation_degrees ==180:
			caminoArriba=true
			caminoDerecha=true
			caminoIzquierda=true
			caminoAbajo=false
		elif $Imagen.rotation_degrees ==270:
			caminoArriba=true
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=true
	pass
func esHabilitado():
	return habilitado
	
func esDestruido():
	return destruido
	
func subir():
	var exito=false
	if getAdyArriba()!=null:
		if getCaminoArriba() and getAdyArriba().getCaminoAbajo():
			exito=true
	return exito
func bajar():
	var exito=false
	if getAdyAbajo()!=null:
		if getCaminoAbajo() and getAdyAbajo().getCaminoArriba():
			exito=true
	return exito
func derecha():
	var exito=false
	if getAdyDerecha()!=null:
		if getCaminoDerecha() and getAdyDerecha().getCaminoIzquierda():
			exito=true
	return exito
func izquierda():
	var exito=false
	if getAdyIzquierda()!=null:
		if getCaminoIzquierda() and getAdyIzquierda().getCaminoDerecha():
			exito=true
	return exito
	
func posicion():
	return {"x":position.x,"y":position.y}
	
func resaltar():
	#resalta las casillas en las que el jugador se puede desplazar y tambien resalta las casillas en las que se puede construir
	#teniendo en cuenta el estado de la casilla, asigna la textura correspondiente
	#Si esta habilitado, pero no construido --> textura de construccion
	#si esta habilitado y construido --> textura de habilitado
	#si esta destruido --> textura prohibido
	if destruido:
		$seleccion.texture = tex_Prohibido
		pass
	else:
		if habilitado and construido:
			$seleccion.texture = tex_Habilitado
		else:
			$seleccion.texture = tex_Construir
		
	pass

func buscarMinero(nroPeer,nroMinero):
	#busca dentro del socket una ficha especifica, con el nro se busca de quien es la ficha y con nroMinero cual de las 3 fichas es buscada
	var exito = true
	var cont = 0
	var minero
	while(exito):
		if (mineros[cont].getNroPeer() == nroPeer) and (mineros[cont].getNroMinero() == nroMinero):
			exito = false#verifica el numero del jugador y el numero de minero
			minero = mineros[cont]
			print("busqueda de minero")
		cont+=1
	return minero
	pass
func sacarMinero(minero):
	var nro = detectarMinero(minero)
	mineros.remove(nro)#quita el minero detectado del socket
	actualizarCantMineros()
	pass
func actualizarCantMineros():
	var tamanio = mineros.size()
	if tamanio == 1:
		mineros[0].posicion($Position1)
		mineros[0].setTamanio(tamanio)
	elif tamanio ==2:
		mineros[0].posicion($Position2_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position2_2)
		mineros[1].setTamanio(tamanio)
	elif tamanio ==3:
		mineros[0].posicion($Position3_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position3_2)
		mineros[2].posicion($Position3_3)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
	elif tamanio ==4:
		mineros[0].posicion($Position4_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position4_2)
		mineros[2].posicion($Position4_3)
		mineros[3].posicion($Position4_4)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
	elif tamanio ==5:
		mineros[0].posicion($Position5_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position5_2)
		mineros[2].posicion($Position5_3)
		mineros[3].posicion($Position5_4)
		mineros[4].posicion($Position5_5)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
	elif tamanio ==6:
		mineros[0].posicion($Position6_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position6_2)
		mineros[2].posicion($Position6_3)
		mineros[3].posicion($Position6_4)
		mineros[4].posicion($Position6_5)
		mineros[5].posicion($Position6_6)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
	elif tamanio ==7:
		mineros[0].posicion($Position7_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position7_2)
		mineros[2].posicion($Position7_3)
		mineros[3].posicion($Position7_4)
		mineros[4].posicion($Position7_5)
		mineros[5].posicion($Position7_6)
		mineros[6].posicion($Position7_7)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
	elif tamanio ==8:
		mineros[0].posicion($Position8_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position8_2)
		mineros[2].posicion($Position8_3)
		mineros[3].posicion($Position8_4)
		mineros[4].posicion($Position8_5)
		mineros[5].posicion($Position8_6)
		mineros[6].posicion($Position8_7)
		mineros[7].posicion($Position8_8)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
	elif tamanio ==9:
		mineros[0].posicion($Position9_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position9_2)
		mineros[2].posicion($Position9_3)
		mineros[3].posicion($Position9_4)
		mineros[4].posicion($Position9_5)
		mineros[5].posicion($Position9_6)
		mineros[6].posicion($Position9_7)
		mineros[7].posicion($Position9_8)
		mineros[8].posicion($Position9_9)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
	elif tamanio ==10:
		mineros[0].posicion($Position10_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position10_2)
		mineros[2].posicion($Position10_3)
		mineros[3].posicion($Position10_4)
		mineros[4].posicion($Position10_5)
		mineros[5].posicion($Position10_6)
		mineros[6].posicion($Position10_7)
		mineros[7].posicion($Position10_8)
		mineros[8].posicion($Position10_9)
		mineros[9].posicion($Position10_10)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
		mineros[9].setTamanio(tamanio)
	elif tamanio ==11:
		mineros[0].posicion($Position11_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position11_2)
		mineros[2].posicion($Position11_3)
		mineros[3].posicion($Position11_4)
		mineros[4].posicion($Position11_5)
		mineros[5].posicion($Position11_6)
		mineros[6].posicion($Position11_7)
		mineros[7].posicion($Position11_8)
		mineros[8].posicion($Position11_9)
		mineros[9].posicion($Position11_10)
		mineros[10].posicion($Position11_11)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
		mineros[9].setTamanio(tamanio)
		mineros[10].setTamanio(tamanio)
	elif tamanio ==12:
		mineros[0].posicion($Position12_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position12_2)
		mineros[2].posicion($Position12_3)
		mineros[3].posicion($Position12_4)
		mineros[4].posicion($Position12_5)
		mineros[5].posicion($Position12_6)
		mineros[6].posicion($Position12_7)
		mineros[7].posicion($Position12_8)
		mineros[8].posicion($Position12_9)
		mineros[9].posicion($Position12_10)
		mineros[10].posicion($Position12_11)
		mineros[11].posicion($Position12_12)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
		mineros[9].setTamanio(tamanio)
		mineros[10].setTamanio(tamanio)
		mineros[11].setTamanio(tamanio)
	pass
func detectarMinero(minero):
	#devuelve la posicion del minero dentro del arreglo de mineros
	var exito = false
	var i =-1
	while(!exito):
		i+=1
		if mineros[i].nroPeer == minero.nroPeer and mineros[i].nroMinero == minero.nroMinero:
			exito=true
		pass
	return i
	pass
func ponerMinero(minero):
	if tipoFicha == "FichaOro":
		minero.ponerOro()
		pass
	if tipoFicha == "FichaEntrada":
		if minero.tieneOro:
			minero.sacarOro()
			minero.extraeOro()
		pass
	mineros.append(minero)
	var tamanio = mineros.size()
	if tamanio == 1:
		mineros[0].posicion($Position1)
		mineros[0].setTamanio(tamanio)
	elif tamanio ==2:
		mineros[0].posicion($Position2_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position2_2)
		mineros[1].setTamanio(tamanio)
	elif tamanio ==3:
		mineros[0].posicion($Position3_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position3_2)
		mineros[2].posicion($Position3_3)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
	elif tamanio ==4:
		mineros[0].posicion($Position4_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position4_2)
		mineros[2].posicion($Position4_3)
		mineros[3].posicion($Position4_4)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
	elif tamanio ==5:
		mineros[0].posicion($Position5_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position5_2)
		mineros[2].posicion($Position5_3)
		mineros[3].posicion($Position5_4)
		mineros[4].posicion($Position5_5)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
	elif tamanio ==6:
		mineros[0].posicion($Position6_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position6_2)
		mineros[2].posicion($Position6_3)
		mineros[3].posicion($Position6_4)
		mineros[4].posicion($Position6_5)
		mineros[5].posicion($Position6_6)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
	elif tamanio ==7:
		mineros[0].posicion($Position7_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position7_2)
		mineros[2].posicion($Position7_3)
		mineros[3].posicion($Position7_4)
		mineros[4].posicion($Position7_5)
		mineros[5].posicion($Position7_6)
		mineros[6].posicion($Position7_7)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
	elif tamanio ==8:
		mineros[0].posicion($Position8_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position8_2)
		mineros[2].posicion($Position8_3)
		mineros[3].posicion($Position8_4)
		mineros[4].posicion($Position8_5)
		mineros[5].posicion($Position8_6)
		mineros[6].posicion($Position8_7)
		mineros[7].posicion($Position8_8)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
	elif tamanio ==9:
		mineros[0].posicion($Position9_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position9_2)
		mineros[2].posicion($Position9_3)
		mineros[3].posicion($Position9_4)
		mineros[4].posicion($Position9_5)
		mineros[5].posicion($Position9_6)
		mineros[6].posicion($Position9_7)
		mineros[7].posicion($Position9_8)
		mineros[8].posicion($Position9_9)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
	elif tamanio ==10:
		mineros[0].posicion($Position10_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position10_2)
		mineros[2].posicion($Position10_3)
		mineros[3].posicion($Position10_4)
		mineros[4].posicion($Position10_5)
		mineros[5].posicion($Position10_6)
		mineros[6].posicion($Position10_7)
		mineros[7].posicion($Position10_8)
		mineros[8].posicion($Position10_9)
		mineros[9].posicion($Position10_10)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
		mineros[9].setTamanio(tamanio)
	elif tamanio ==11:
		mineros[0].posicion($Position11_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position11_2)
		mineros[2].posicion($Position11_3)
		mineros[3].posicion($Position11_4)
		mineros[4].posicion($Position11_5)
		mineros[5].posicion($Position11_6)
		mineros[6].posicion($Position11_7)
		mineros[7].posicion($Position11_8)
		mineros[8].posicion($Position11_9)
		mineros[9].posicion($Position11_10)
		mineros[10].posicion($Position11_11)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
		mineros[9].setTamanio(tamanio)
		mineros[10].setTamanio(tamanio)
	elif tamanio ==12:
		mineros[0].posicion($Position12_1)
		mineros[0].setTamanio(tamanio)
		mineros[1].posicion($Position12_2)
		mineros[2].posicion($Position12_3)
		mineros[3].posicion($Position12_4)
		mineros[4].posicion($Position12_5)
		mineros[5].posicion($Position12_6)
		mineros[6].posicion($Position12_7)
		mineros[7].posicion($Position12_8)
		mineros[8].posicion($Position12_9)
		mineros[9].posicion($Position12_10)
		mineros[10].posicion($Position12_11)
		mineros[11].posicion($Position12_12)
		mineros[1].setTamanio(tamanio)
		mineros[2].setTamanio(tamanio)
		mineros[3].setTamanio(tamanio)
		mineros[4].setTamanio(tamanio)
		mineros[5].setTamanio(tamanio)
		mineros[6].setTamanio(tamanio)
		mineros[7].setTamanio(tamanio)
		mineros[8].setTamanio(tamanio)
		mineros[9].setTamanio(tamanio)
		mineros[10].setTamanio(tamanio)
		mineros[11].setTamanio(tamanio)
	
	pass
	
func desResaltar():
	$seleccion.texture=null

func _on_TextureButton_pressed():
	print("pos real x = "+str(position.x)+"pos real y = "+str(position.y))
	print(jugadores.size())
	var ficha 
	var tipo
	var rotacion
	var posicionFicha
	if $seleccion.texture==tex_Construir and get_tree().get_root().get_node("Mundo").fichaEnMano!=null:
		
		tipo=get_tree().get_root().get_node("Mundo").fichaEnMano.getTipo()
		print(tipo)
		if tipo!="FichaDinamita":
			rotacion=get_tree().get_root().get_node("Mundo").fichaEnMano.getRotacion()
			#determinar la posicion del jugador, para saber hacia donde se va a mover el jugador despues de la construccion
			posicionFicha = get_tree().get_root().get_node("Mundo").obtenerPosicionSocket(position.x,position.y)
			var posicionJugador = get_tree().get_root().get_node("Mundo").jugadorActual.getPosicion()
			#verificar si el jugador tiene suficientes puntos para realizar la construccion
			var puntos =get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos
			print(puntos)
			if puntos>0:
				var habilitado=false
				if tipo == "FichaI":
					get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos-=1
					habilitado=true
				elif tipo == "FichaL"and puntos>=2:
					get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos-=2
					habilitado=true
				elif tipo == "FichaT"and puntos>=3:
					get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos-=3
					habilitado=true
				elif tipo == "FichaCruz"and puntos>=4:
					get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos-=4
					habilitado=true
				elif tipo == "FichaEntrada"and puntos>=6:
					get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos-=6
					habilitado=true
				if habilitado:
					get_tree().get_root().get_node("Mundo").quitarFichaMano()
					construir(tipo,rotacion)
					if (posicionFicha.x-posicionJugador.x) <0:
						Network.llamada("Mundo","quitarJugador",{"x":posicionJugador.x,"y":posicionJugador.y,"id":get_tree().get_network_unique_id()})
						#mapa.quitarJugador(posx,posy,get_tree().get_network_unique_id())
						get_tree().get_root().get_node("Mundo/Mapa").quitarJugador(posicionJugador.x,posicionJugador.y,get_tree().get_network_unique_id())
						get_tree().get_root().get_node("Mundo").jugadorActual.izquierda()
						#mapa.agregarJugador(posx,posy,get_tree().get_network_unique_id())
						get_tree().get_root().get_node("Mundo/Mapa").agregarJugador(posicionFicha.x,posicionFicha.y,get_tree().get_network_unique_id())
						Network.llamada("Mundo","agregarJugador",{"x":posicionFicha.x,"y":posicionFicha.y,"id":get_tree().get_network_unique_id()})
					elif (posicionFicha.x-posicionJugador.x) >0:
						Network.llamada("Mundo","quitarJugador",{"x":posicionJugador.x,"y":posicionJugador.y,"id":get_tree().get_network_unique_id()})
						get_tree().get_root().get_node("Mundo/Mapa").quitarJugador(posicionJugador.x,posicionJugador.y,get_tree().get_network_unique_id())
						get_tree().get_root().get_node("Mundo").jugadorActual.derecha()
						get_tree().get_root().get_node("Mundo/Mapa").agregarJugador(posicionFicha.x,posicionFicha.y,get_tree().get_network_unique_id())
						Network.llamada("Mundo","agregarJugador",{"x":posicionFicha.x,"y":posicionFicha.y,"id":get_tree().get_network_unique_id()})
					if (posicionFicha.y-posicionJugador.y) <0:
						Network.llamada("Mundo","quitarJugador",{"x":posicionJugador.x,"y":posicionJugador.y,"id":get_tree().get_network_unique_id()})
						get_tree().get_root().get_node("Mundo/Mapa").quitarJugador(posicionJugador.x,posicionJugador.y,get_tree().get_network_unique_id())
						get_tree().get_root().get_node("Mundo").jugadorActual.subir()
						get_tree().get_root().get_node("Mundo/Mapa").agregarJugador(posicionFicha.x,posicionFicha.y,get_tree().get_network_unique_id())
						Network.llamada("Mundo","agregarJugador",{"x":posicionFicha.x,"y":posicionFicha.y,"id":get_tree().get_network_unique_id()})
					elif (posicionFicha.y-posicionJugador.y) >0:
						Network.llamada("Mundo","quitarJugador",{"x":posicionJugador.x,"y":posicionJugador.y,"id":get_tree().get_network_unique_id()})
						get_tree().get_root().get_node("Mundo/Mapa").quitarJugador(posicionJugador.x,posicionJugador.y,get_tree().get_network_unique_id())
						get_tree().get_root().get_node("Mundo").jugadorActual.bajar()
						get_tree().get_root().get_node("Mundo/Mapa").agregarJugador(posicionFicha.x,posicionFicha.y,get_tree().get_network_unique_id())
						Network.llamada("Mundo","agregarJugador",{"x":posicionFicha.x,"y":posicionFicha.y,"id":get_tree().get_network_unique_id()})
					#restar de la mano del jugar actual la ficha construida
					if tipo == "FichaEntrada":
						tipo = "FichaEntrada"
					get_tree().get_root().get_node("Mundo").jugadorActual.sacarFicha(tipo)
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
					#actualizar a todos los jugadores sobre la creacion de la ficha
					Network.llamada("Mundo","construir",{"tipo":tipo,"rotacion":rotacion,"x":posicionFicha.x,"y":posicionFicha.y})
				pass
	if construido and get_tree().get_root().get_node("Mundo").fichaEnMano !=null and mineros.size()==0 and tipoFicha != "FichaOro" and jugadores.size()==0:
		posicionFicha = get_tree().get_root().get_node("Mundo").obtenerPosicionSocket(position.x,position.y)
		tipo=get_tree().get_root().get_node("Mundo").fichaEnMano.getTipo()
		if tipo=="FichaDinamita":
			if get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos>=3:
				#preguntar a los demas jugadores si esa casilla esta habilitada para ser destruida( si hay mineros o el jugador)
					get_tree().get_root().get_node("Mundo").jugadorActual.datos.puntos-=3
					#construir("FichaTierra2",0)
					destruir()
					get_tree().get_root().get_node("Mundo").quitarFichaMano()
					Network.llamada("Mundo","destruir",{"x":posicionFicha.x,"y":posicionFicha.y})
					get_tree().get_root().get_node("Mundo").jugadorActual.sacarFicha(tipo)
					get_tree().get_root().get_node("Mundo").mostrarPuntosJugadorActual()
		pass
		
	pass # Replace with function body.
