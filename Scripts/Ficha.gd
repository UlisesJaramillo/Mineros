extends Node2D

# Ésta es la clase principar de las fichas.
# tiene un a variable para almacenar el Sprite de la ficha
#tiene una variable para el nombre, la cantidad de oro si es una ficha de oro.
#tiene que tener un constructor abstracto para permitir la constuccion de cualquier tipo de ficha.



#////////////////////////////////////////////////////////
#VARIABLES
var textura
var tipo#tipo de ficha
var caminoArriba=false
var caminoAbajo=false			#tiene en cuenta si estan disponibles los caminos para poder moverse o construir
var caminoIzquierda=false
var caminoDerecha=false
var constRot=0


#///////////////////////////////////////////////////////////
#METODOS

func init(posX,posY,tipo):
	position.x=posX
	position.y=posY
	ponerImagen(tipo,1)
	pass
func actualizar():
	
	pass
func getCaminoArriba():
	return caminoArriba
	
func getCaminoAbajo():
	return caminoAbajo
	
func getCaminoIzquierda():
	return caminoIzquierda
	
func getCaminoDerecha():
	return caminoDerecha
	
func ponerImagen(tipo,rotacion):
	if tipo == "fichaI":
		textura = load("res://Texturas/fichaI.png")
		tipo = "fichaI"
		caminoArriba=false
		caminoAbajo=false
		caminoIzquierda=true
		caminoDerecha=true
	elif tipo == "fichaL":
		textura = load("res://Texturas/fichaL.png")
		tipo = "fichaL"
		caminoArriba=false
		caminoDerecha=true
		caminoIzquierda=false
		caminoAbajo=true
	elif tipo == "fichaT":
		textura = load("res://Texturas/fichaT.png")
		tipo = "fichaT"
		caminoArriba=false
		caminoIzquierda=true
		caminoDerecha=true
		caminoAbajo=true
	elif tipo == "fichaCruz":
		textura = load("res://Texturas/fichaCruz.png")
		tipo = "fichaCruz"
		caminoArriba=true
		caminoIzquierda=true
		caminoDerecha=true
		caminoAbajo=true
	elif tipo == "fichaOro":
		textura = load("res://Texturas/fichaOro.png")
		tipo = "fichaOro"
		caminoArriba=true
		caminoIzquierda=true
		caminoDerecha=true
		caminoAbajo=true
	elif tipo == "fichaDestruido":
		textura = load("res://Texturas/fichaTierra2.png")
		tipo = "fichaDestruido"
		caminoArriba=false
		caminoIzquierda=false
		caminoDerecha=false
		caminoAbajo=false
	elif tipo == "fichaTierra":
		textura = load("res://Texturas/fichaTierra.png")
		tipo = "fichaTierra"
		caminoArriba=false
		caminoIzquierda=false
		caminoDerecha=false
		caminoAbajo=false
	$Imagen.texture = textura
	rotacion(rotacion)#reset de la rotacion
	pass
func rotacion(rot):
	if rot==2:
		girar()
	elif rot==3:
		girar()
		girar()
	elif rot==4:
		girar()
		girar()
		girar()
		

func girar():
	var rot = $Imagen.rotation_degrees
	$Imagen.rotation_degrees = rot +90
	
	if tipo == "fichaI":
		if $Imagen.rotation_degrees % 90 ==0:
			caminoArriba=true
			caminoAbajo=true
			caminoIzquierda=false
			caminoDerecha=false
		else:
			caminoArriba=false
			caminoAbajo=false
			caminoIzquierda=true
			caminoDerecha=true
	elif tipo == "fichaL":
		if $Imagen.rotation_degrees % 0 ==0:
			caminoArriba=false
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=true
		if $Imagen.rotation_degrees % 90 ==0:
			caminoArriba=false
			caminoDerecha=true
			caminoIzquierda=false
			caminoAbajo=true
	elif tipo == "fichaT":
		textura = load("res://Texturas/fichaT.png")
		tipo = "fichaT"
		caminoArriba=false
		caminoIzquierda=true
		caminoDerecha=true
		caminoAbajo=true
	
	pass
	
func getTipo():
	return tipo
	pass
