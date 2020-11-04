extends Node2D
#clase principal, responsable de la creaccion de los jugadores, los Sockets y la bolsa de fichas.



#METODOS:
#crearTablero():void crea el tablero hecho por Sockets además crea en el centro una ficha de salida, y cuatro minas en los bordes del tablero.
#crearJugador():void crea un jugador y lo agrega a la coleccion de jugadores
#crearBolsa():void crea una bolsa de fichas.
#






#////////////////////////////////////////////////////////////////////////
#VARIABLES
var contadorTurno=0
var jugadores = []
var jugadorActual
var fichaEnMano
var enMano=false
var botonApretado=0
var nroDado
onready var jugador = preload("res://Escenas/Jugador.tscn")

#TEXTURAS
onready var tex_I = preload("res://Texturas/fichaI.png")
onready var tex_L = preload("res://Texturas/fichaL.png")
onready var tex_T = preload("res://Texturas/fichaT.png")
onready var tex_Cruz = preload("res://Texturas/fichaCruz.png")
onready var tex_Entrada = preload("res://Texturas/fichaEntrada.png")
onready var tex_Dinamita = preload("res://Texturas/fichaDinamita.png")
#DADO
onready var tex_Dado1 = preload("res://Texturas/dado1.png")
onready var tex_Dado2 = preload("res://Texturas/dado2.png")
onready var tex_Dado3 = preload("res://Texturas/dado3.png")
onready var tex_Dado4 = preload("res://Texturas/dado4.png")
onready var tex_Dado5 = preload("res://Texturas/dado5.png")
onready var tex_Dado6 = preload("res://Texturas/dado6.png")
#FICHA
onready var ficha = preload("res://Escenas/Socket.tscn")
onready var ficha_prueba = preload("res://Escenas/fichita_prueba.tscn")
onready var ficha_minero = preload("res://Minero.tscn")
#/////////////////////////////////////////////////////////////////////////
#METODOS


func _ready():
	pass
func obtenerPosicionSocket(posx,posy):
	return $Mapa.obtenerPosicionSocket(posx,posy)
	
func agregarJugador(id,nombre):
	#metodo que me permite crear un jugador
	var instancia = jugador.instance()
	jugadores.append(instancia)
	print("numero de jugadores = "+str(jugadores.size()))
	instancia.init(nombre,$Mapa,id,jugadores.size())
	if get_tree().get_network_unique_id() == 1:
		
		instancia.empezarTurno()
		#instancia.crearMineros()
		$Control/CanvasLayer/VBoxContainer4/HBoxContainer/TerminarTurno.show()
		$Control/CanvasLayer/VBoxContainer4/HBoxContainer/TirarDado.show()
		for i in range(6):
			instancia.ponerFicha($Bolsa.sacarFicha())
		
	if get_tree().get_network_unique_id() == id:
		jugadorActual=instancia
		
		add_child(instancia)
		#instancia.crearMineros()#se crean los mineros una vez que se agrego el nodo al mundo
		
		if get_tree().get_network_unique_id() != 1:
			Network.llamada_id(1,"Mundo","pedirNroJugador",get_tree().get_network_unique_id())#le pide el numero de jugador
			for i in range(6):#solicitar al servidor las 6 fichas que necesita para jugar
				Network.llamada_id(1,"Mundo","sacarFicha",get_tree().get_network_unique_id())
			pass
		
		mostrarManoMenu()
		instancia.crearMineros()
		instancia.setNroPeerMineros(get_tree().get_network_unique_id())
		tablaPuntajeLocal()
		Network.llamada("Mundo","tablaPuntaje",{"id":get_tree().get_network_unique_id(),"cantOro":jugadorActual.getCantOro()})
	#crear los mineros correspondiente a cada jugador
	pass
func ponerFichaMinero(datos):
	var instancia = ficha_minero.instance()
	add_child(instancia)
	instancia.setNroMinero(datos.nroMinero)
	$Mapa.ponerMinero(instancia,datos.posx,datos.posy)
	instancia.ponerImagen(datos.nro)
	instancia.setNroPeer(datos.nroPeer)
	print("nro peer"+str(datos.nro))
	pass

func moverFichaMinero(datos):
	#metodo que se encarga de encontrar un minero en la posicion de origen y moverlo al destino
	#sirve para actualizar la posicion de las fichas de mineros en los demas clientes
	var minero = $Mapa.buscarMinero(datos.nroPeer,datos.nroMinero,datos.origenX,datos.origenY)
	$Mapa.sacarMinero(minero,datos.origenX,datos.origenY)
	minero.setPosX(datos.destinoX)
	minero.setPosY(datos.destinoY)
	$Mapa.ponerMinero(minero,datos.destinoX,datos.destinoY)
	pass
func entregarFichas(id):
	for i in range(3):
		Network.llamada_id(id,"Mundo","ponerFichaMinero",{"nro":jugadorActual.nroJugador,"nroPeer":get_tree().get_network_unique_id(),"posx":7,"posy":7,"nroMinero":i})
	pass
func tirarDado():
	#el tirar dado depende de cada jugador, en este caso de cada cliente, una vez tirado el dado se le notifica a los
	#demas el valor obtenido
	randomize()
	var num = (randi()%6)+1
	nroDado=num
	return num
	pass
func pedirNroJugador(id):
	Network.llamada_id(id,"Mundo","asignarNroJugador",jugadores.size())
func ponerImagenDado(dato):
	#segun el dato, coloco la imagen correspondiente
	if nroDado==1:
		$Control/CanvasLayer/CenterContainer/Dado.texture=tex_Dado1
	elif nroDado==2:
		$Control/CanvasLayer/CenterContainer/Dado.texture=tex_Dado2
	elif nroDado==3:
		$Control/CanvasLayer/CenterContainer/Dado.texture=tex_Dado3
	elif nroDado==4:
		$Control/CanvasLayer/CenterContainer/Dado.texture=tex_Dado4
	elif nroDado==5:
		$Control/CanvasLayer/CenterContainer/Dado.texture=tex_Dado5
	elif nroDado==6:
		$Control/CanvasLayer/CenterContainer/Dado.texture=tex_Dado6
	$Control/CanvasLayer/CenterContainer/Dado.show()
	pass
func sacarFicha(id_origen):
	#para sacar una ficha de la bolsa de fichas cada cliente solicita al servidor la ficha
	var ficha = $Bolsa.sacarFicha()
	Network.llamada_id(id_origen,"Mundo","agregarFicha",ficha)
	pass
func agregarFicha(dato):
	jugadorActual.ponerFicha(dato)
	pass
func construir(tipo,rotacion,x,y):
	#cuando un cliente construye se le notifica a cada cliente que ficha, la posicion y su rotacion, para que cada cliente
	#pueda actualizar su tablero
	$Mapa.construir(tipo,rotacion,x,y)
	pass
func destruir(x,y):
	#idem construir
	$Mapa.destruir(x,y)
	pass
func posicionJugador(id,x,y):
	#cada vez que un jugador se mueva, tiene que notificar a todos los clientes
	pass
func mostrarManoMenu():
	var mano = jugadorActual.getMano().duplicate()
	for i in range(mano.size()):
		if i ==0:
			if mano["FichaI"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal=tex_I
				mano["FichaI"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.show()
			elif mano["FichaL"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal=tex_L
				mano["FichaL"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.show()
			elif mano["FichaT"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal=tex_T
				mano["FichaT"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.show()
			elif mano["FichaCruz"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal=tex_Cruz
				mano["FichaCruz"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.show()
			elif mano["FichaEntrada"] >0:#posible correcion de nombre salida o entrada
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal=tex_Entrada
				mano["FichaEntrada"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.show()
			elif mano["FichaDinamita"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal=tex_Dinamita
				mano["FichaDinamita"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.show()
		if i ==1:
			if mano["FichaI"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal=tex_I
				mano["FichaI"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.show()
			elif mano["FichaL"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal=tex_L
				mano["FichaL"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.show()
			elif mano["FichaT"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal=tex_T
				mano["FichaT"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.show()
			elif mano["FichaCruz"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal=tex_Cruz
				mano["FichaCruz"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.show()
			elif mano["FichaEntrada"] >0:#posible correcion de nombre salida o entrada
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal=tex_Entrada
				mano["FichaEntrada"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.show()
			elif mano["FichaDinamita"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal=tex_Dinamita
				mano["FichaDinamita"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.show()
		if i ==2:
			if mano["FichaI"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal=tex_I
				mano["FichaI"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.show()
			elif mano["FichaL"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal=tex_L
				mano["FichaL"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.show()
			elif mano["FichaT"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal=tex_T
				mano["FichaT"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.show()
			elif mano["FichaCruz"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal=tex_Cruz
				mano["FichaCruz"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.show()
			elif mano["FichaEntrada"] >0:#posible correcion de nombre salida o entrada
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal=tex_Entrada
				mano["FichaEntrada"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.show()
			elif mano["FichaDinamita"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal=tex_Dinamita
				mano["FichaDinamita"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.show()
		if i ==3:
			if mano["FichaI"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal=tex_I
				mano["FichaI"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.show()
			elif mano["FichaL"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal=tex_L
				mano["FichaL"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.show()
			elif mano["FichaT"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal=tex_T
				mano["FichaT"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.show()
			elif mano["FichaCruz"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal=tex_Cruz
				mano["FichaCruz"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.show()
			elif mano["FichaEntrada"] >0:#posible correcion de nombre salida o entrada
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal=tex_Entrada
				mano["FichaEntrada"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.show()
			elif mano["FichaDinamita"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal=tex_Dinamita
				mano["FichaDinamita"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.show()
		if i ==4:
			if mano["FichaI"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal=tex_I
				mano["FichaI"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.show()
			elif mano["FichaL"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal=tex_L
				mano["FichaL"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.show()
			elif mano["FichaT"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal=tex_T
				mano["FichaT"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.show()
			elif mano["FichaCruz"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal=tex_Cruz
				mano["FichaCruz"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.show()
			elif mano["FichaEntrada"] >0:#posible correcion de nombre salida o entrada
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal=tex_Entrada
				mano["FichaEntrada"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.show()
			elif mano["FichaDinamita"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal=tex_Dinamita
				mano["FichaDinamita"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.show()
		if i ==5:
			if mano["FichaI"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal=tex_I
				mano["FichaI"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.show()
			elif mano["FichaL"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal=tex_L
				mano["FichaL"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.show()
			elif mano["FichaT"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal=tex_T
				mano["FichaT"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.show()
			elif mano["FichaCruz"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal=tex_Cruz
				mano["FichaCruz"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.show()
			elif mano["FichaEntrada"] >0:#posible correcion de nombre salida o entrada
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal=tex_Entrada
				mano["FichaEntrada"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.show()
			elif mano["FichaDinamita"] >0:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal=tex_Dinamita
				mano["FichaDinamita"]-=1
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.show()
	pass
func iniciarJuego():
	pass
func asignarNroJugador(nro):
	jugadorActual.setNroJugador(nro)
	jugadorActual.setNroJugadorMineros(nro)
	jugadorActual.asignarColorMineros(nro)
	for i in range(3):
		Network.llamada("Mundo","ponerFichaMinero",{"nro":nro,"posx":7,"posy":7,"nroMinero":i,"nroPeer":get_tree().get_network_unique_id()})
	pass
func correrFuncionDelServidor(funcion,dato):
	#metodo que sirve para hacer las llamadas a todas las funciones necesarias para sincronizar a los clientes
	if funcion == "ponerImagenDado":
		ponerImagenDado(dato)
	if funcion =="destruir":
		destruir(dato.x,dato.y)
	if funcion =="construir":
		construir(dato.tipo,dato.rotacion,dato.x,dato.y)
	if funcion == "sacarFicha":
		sacarFicha(dato)
	if funcion =="print":
		print(dato)
	if funcion =="empezarTurno":
		empezarTurno(dato)
		pass
	if funcion=="empiezaTurno":
		empiezaTurno(dato)
	if funcion == "_on_TerminarTurno_pressed":
		_on_TerminarTurno_pressed()
		pass
	if funcion == "agregarFicha":
		agregarFicha(dato)
	if funcion == "asignarNroJugador":
		asignarNroJugador(dato)
	if funcion == "pedirNroJugador":
		pedirNroJugador(dato)
	if funcion =="ponerFichaMinero":
		ponerFichaMinero(dato)
	if funcion == "solicitarFichasMinero":
		entregarFichas(dato)
	if funcion == "moverFichaMinero":
		moverFichaMinero(dato)
	if funcion == "tablaPuntaje":
		tablaPuntaje(dato)
	if funcion == "actualizarTabla":
		actualizarTabla(dato)
	if funcion == "cartelVictoria":
		cartelVictoria(dato)
	if funcion == "agregarJugador":
		sumaJugador(dato)
	if funcion == "quitarJugador":
		restaJugador(dato)
	pass
func sumaJugador(dato):
	$Mapa.agregarJugador(dato.x,dato.y,dato.id)
func restaJugador(dato):
	$Mapa.quitarJugador(dato.x,dato.y,dato.id)
func cartelVictoria(dato):
	var texto
	for i in range(jugadores.size()):
		if jugadores[i].datos.id == dato:
			texto=jugadores[i].datos.nombre
	$Control/CanvasLayer/AcceptDialog.dialog_text=texto
	$Control/CanvasLayer/AcceptDialog.popup_centered()
	pass
func tablaPuntajeLocal():
	var texto=""
	for i in range(jugadores.size()):
		texto=texto+jugadores[i].datos.nombre+"  Oro = "+str(jugadores[i].datos.cantOro)+"\n"
	$Control/CanvasLayer/MarginContainer/TablaPuntaje.text=texto
func tablaPuntaje(dato):
	var texto=""
	for i in range(jugadores.size()):
		if jugadores[i].datos.id == dato.id:
			jugadores[i].datos.cantOro = dato.cantOro
	for i in range(jugadores.size()):
		texto=texto+jugadores[i].datos.nombre+"  Oro = "+str(jugadores[i].datos.cantOro)+"\n"
	$Control/CanvasLayer/MarginContainer/TablaPuntaje.text=texto
	#Network.llamada_id(dato.idOrigen,"Mundo","actualizarTabla",texto)REVISAR
	pass
func actualizarTabla(texto):
	$Control/CanvasLayer/MarginContainer/TablaPuntaje.text=texto
func _on_Crear_pressed():
	#metodo para crear el servidor
	var nombre = $Control/CanvasLayer/Menu/PanelContainer/VBoxContainer/HBoxContainer3/nombreJugador.text
	var ip = $Control/CanvasLayer/Menu/PanelContainer/VBoxContainer/HBoxContainer/ip.text
	var puerto = $Control/CanvasLayer/Menu/PanelContainer/VBoxContainer/HBoxContainer2/puerto.text
	Network.create_server(nombre,puerto)
	$Control/CanvasLayer/Menu.hide()
	$Camera2D.habilitar()
	pass # Replace with function body.


func _on_Unirse_pressed():
	var nombre = $Control/CanvasLayer/Menu/PanelContainer/VBoxContainer/HBoxContainer3/nombreJugador.text
	var ip = $Control/CanvasLayer/Menu/PanelContainer/VBoxContainer/HBoxContainer/ip.text
	var puerto = $Control/CanvasLayer/Menu/PanelContainer/VBoxContainer/HBoxContainer2/puerto.text
	Network.create_client(nombre,ip,puerto)
	$Control/CanvasLayer/Menu.hide()
	$Camera2D.habilitar()
	pass


func _on_TerminarTurno_pressed():#solamete el servidor controla el manejo de los turnos
	$Control/CanvasLayer/VBoxContainer4/HBoxContainer/TerminarTurno.hide()
	$Control/CanvasLayer/CenterContainer/Dado.hide()
	jugadorActual.finTurno()
	var nro =0
	quitarFichaMano()
	if get_tree().get_network_unique_id() == 1:
		nro=terminarTurno()
		var jugador = jugadores[nro]
		if jugador.datos.id==1:
			empezarTurno(jugadorActual.datos.nombre)
			pass
		else:
			Network.llamada_id(jugador.datos.id,"Mundo","empezarTurno",jugador.datos.nombre)
	else:
		Network.llamada_id(1,"Mundo","_on_TerminarTurno_pressed",nro)
		pass
	pass
	
func empezarTurno(nombre):
	jugadorActual.empezarTurno()
	$Control/CanvasLayer/VBoxContainer4/HBoxContainer/TerminarTurno.show()
	$Control/CanvasLayer/VBoxContainer4/HBoxContainer/TirarDado.show()
	Network.llamada("Mundo","empiezaTurno",nombre)
	#sacar una cantidad de fichas igual a las faltantes hasta completar 6 fichas
	print(jugadorActual.getCantidadFichas())
	var nro = 6-jugadorActual.getCantidadFichas()
	print(nro)
	if get_tree().get_network_unique_id()==1:
		if nro>0:
			for i in range(nro):
				jugadorActual.ponerFicha($Bolsa.sacarFicha())
	else:
		if nro>0:
			for i in range(nro):
				Network.llamada_id(1,"Mundo","sacarFicha",get_tree().get_network_unique_id())
	mostrarManoMenu()
	empiezaTurno(nombre)
	pass
	
func empiezaTurno(nombre):
	$Control/CanvasLayer/VBoxContainer3/HBoxContainer/Label.text="Turno de: "+ nombre
	pass
	
func terminarTurno():
	#al terminar un turno, pasa al segundo jugador de la coleccion
	contadorTurno+=1
	var nro = ((contadorTurno))%jugadores.size()
	return nro
	#se tiene que avisar a los demas jugadores de quien es el turno
	#solamente el servidor controla el terminar turno
	#los clientes al terminar su turno hace un llamado al servido para que se encargue de terminar el turno
	pass
func _process(delta):
	if enMano:
		fichaEnMano.position = get_global_mouse_position()
	pass
	
func _input(event):
	if fichaEnMano!=null:
		if event.is_action_pressed("cancelarSeleccion"):
			quitarFichaMano()
			$cancelar.play()
			if botonApretado==6:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.show()
			elif botonApretado==5:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.show()
			elif botonApretado==4:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.show()
			elif botonApretado==3:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.show()
			elif botonApretado==2:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.show()
			elif botonApretado==1:
				$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.show()
			
		if event.is_action_pressed("rotarSeleccion"):
			fichaEnMano.rotar()
			pass
func quitarFichaMano():
	if fichaEnMano!=null:
		enMano=false
		fichaEnMano.queue_free()
		fichaEnMano=null
	pass
func _on_TextureButton_pressed():
	var tipo
	if $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal == tex_I:
		tipo = "FichaI"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal == tex_L:
		tipo = "FichaL"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal == tex_T:
		tipo = "FichaT"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal == tex_Cruz:
		tipo = "FichaCruz"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal == tex_Entrada:
		tipo = "FichaEntrada"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.texture_normal == tex_Dinamita:
		tipo = "FichaDinamita"
	if !enMano:
		$agarrarFicha.play()
		var instancia = ficha_prueba.instance()
		fichaEnMano = instancia
		add_child(instancia)
		instancia.ponerImagen(tipo)
		enMano=true
		botonApretado=1
		$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton.hide()
	pass # Replace with function body.


func _on_TextureButton2_pressed():
	var tipo
	if $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal == tex_I:
		tipo = "FichaI"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal == tex_L:
		tipo = "FichaL"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal == tex_T:
		tipo = "FichaT"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal == tex_Cruz:
		tipo = "FichaCruz"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal == tex_Entrada:
		tipo = "FichaEntrada"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.texture_normal == tex_Dinamita:
		tipo = "FichaDinamita"
	if !enMano:
		$agarrarFicha.play()
		var instancia = ficha_prueba.instance()
		fichaEnMano = instancia
		add_child(instancia)
		instancia.ponerImagen(tipo)
		enMano=true
		botonApretado=2
		$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton2.hide()
	pass # Replace with function body.


func _on_TextureButton3_pressed():
	var tipo
	if $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal == tex_I:
		tipo = "FichaI"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal == tex_L:
		tipo = "FichaL"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal == tex_T:
		tipo = "FichaT"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal == tex_Cruz:
		tipo = "FichaCruz"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal == tex_Entrada:
		tipo = "FichaEntrada"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.texture_normal == tex_Dinamita:
		tipo = "FichaDinamita"
	if !enMano:
		$agarrarFicha.play()
		var instancia = ficha_prueba.instance()
		fichaEnMano = instancia
		add_child(instancia)
		instancia.ponerImagen(tipo)
		enMano=true
		botonApretado=3
		$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton3.hide()
	pass # Replace with function body.


func _on_TextureButton4_pressed():
	var tipo
	if $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal == tex_I:
		tipo = "FichaI"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal == tex_L:
		tipo = "FichaL"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal == tex_T:
		tipo = "FichaT"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal == tex_Cruz:
		tipo = "FichaCruz"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal == tex_Entrada:
		tipo = "FichaEntrada"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.texture_normal == tex_Dinamita:
		tipo = "FichaDinamita"
	if !enMano:
		$agarrarFicha.play()
		var instancia = ficha_prueba.instance()
		fichaEnMano = instancia
		add_child(instancia)
		instancia.ponerImagen(tipo)
		enMano=true
		botonApretado=4
		$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton4.hide()
	pass # Replace with function body.


func _on_TextureButton5_pressed():
	var tipo
	if $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal == tex_I:
		tipo = "FichaI"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal == tex_L:
		tipo = "FichaL"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal == tex_T:
		tipo = "FichaT"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal == tex_Cruz:
		tipo = "FichaCruz"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal == tex_Entrada:
		tipo = "FichaEntrada"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.texture_normal == tex_Dinamita:
		tipo = "FichaDinamita"
	if !enMano:
		$agarrarFicha.play()
		var instancia = ficha_prueba.instance()
		fichaEnMano = instancia
		add_child(instancia)
		instancia.ponerImagen(tipo)
		enMano=true
		botonApretado=5
		$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton5.hide()
	pass # Replace with function body.


func _on_TextureButton6_pressed():
	var tipo
	if $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal == tex_I:
		tipo = "FichaI"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal == tex_L:
		tipo = "FichaL"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal == tex_T:
		tipo = "FichaT"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal == tex_Cruz:
		tipo = "FichaCruz"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal == tex_Entrada:
		tipo = "FichaEntrada"
	elif $Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.texture_normal == tex_Dinamita:
		tipo = "FichaDinamita"
	if !enMano:
		$agarrarFicha.play()
		var instancia = ficha_prueba.instance()
		fichaEnMano = instancia
		add_child(instancia)
		instancia.ponerImagen(tipo)
		enMano=true
		botonApretado=6
		$Control/CanvasLayer/VBoxContainer2/HBoxContainer/TextureButton6.hide()
	pass # Replace with function body.


func _on_TirarDado_pressed():
	var nro = tirarDado()
	ponerImagenDado(nro)
	$tiraDado.play()
	jugadorActual.setPuntos(nro)
	$Control/CanvasLayer/VBoxContainer4/HBoxContainer/TirarDado.hide()
	mostrarPuntosJugadorActual()
	
	pass # Replace with function body.

func mostrarPuntosJugadorActual():
	$Control/CanvasLayer/VBoxContainer4/HBoxContainer/RichTextLabel.text = "Puntos disponibles: " + str(jugadorActual.datos.puntos)
	pass

func _on_Cambiar_pressed():
	#cambiar ficha con un coste de 1
	var tipo
	if fichaEnMano!=null:
		tipo = fichaEnMano.getTipo()
		var puntos = jugadorActual.datos.puntos
		if puntos>0:
			$cambiaFicha.play()
			jugadorActual.sacarFicha(tipo)
			quitarFichaMano()
			if get_tree().get_network_unique_id()==1:
				jugadorActual.ponerFicha($Bolsa.sacarFicha())
			else:
				Network.llamada_id(1,"Mundo","sacarFicha",get_tree().get_network_unique_id())
			
			mostrarManoMenu()
			jugadorActual.datos.puntos-=1
			mostrarPuntosJugadorActual()
			pass
		pass
	pass # Replace with function body.
