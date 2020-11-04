extends Node

#esta clase almacena en una coleccion las fichas que tiene cada jugador en su mano.
#tiene una variable de la cantidad actual, cantidad maxima y la coleccion
#tiene una vaiable por cada tipo de ficha, para indicar la cantidad de cada una.

#METODOS

#obtenerFicha(String):String  #si no hay ficha devuelve "vacío"
#colocarFicha(String):boolean
#
#//////////////////////////////////////////////////
#CREACION DE VARIABLES

var fichas = {"FichaI":28,"FichaL":28,"FichaT":28,"FichaCruz":18,"FichaDinamita":12,"FichaEntrada":9}
var cantFichasTotal



#///////////////////////////////////////////////////
#METODOS

#CREACION
func _init():
	pass
	
func _ready():
	cantFichasTotal = fichas.FichaI + fichas.FichaL+ fichas.FichaT + fichas.FichaCruz + fichas.FichaDinamita + fichas.FichaEntrada
	
	pass
func sacarFicha():
	#este metodo sumula el sacado de una ficha aleatoria con una probabilidad que depende de la cantidad de fichas de 
	#cada tipo.
	var ficha
	randomize()
	var nro = int(rand_range(1,cantFichasTotal))
	#var nro = (randi()%(cantFichasTotal+1))+1#REVISAR
	if nro <= fichas.FichaI:
		ficha = "FichaI"
		fichas.FichaI-=1
	else:
		nro=nro-fichas.FichaI
		if  nro<=fichas.FichaL:
			ficha = "FichaL"
			fichas.FichaL-=1
		else:
			nro=nro-fichas.FichaL
			if nro<=fichas.FichaT:
				ficha = "FichaT"
				fichas.FichaT-=1
			else:
				nro=nro-fichas.FichaT
				if nro<=fichas.FichaCruz:
					ficha = "FichaCruz"
					fichas.FichaCruz-=1
				else:
					nro=nro-fichas.FichaCruz
					if nro<=fichas.FichaDinamita:
						ficha = "FichaDinamita"
						fichas.FichaDinamita-=1
					else:
						nro=nro-fichas.FichaDinamita
						if nro<=fichas.FichaEntrada:
							ficha = "FichaEntrada"
							fichas.FichaEntrada-=1
						else:
							nro=nro-fichas.FichaEntrada
	cantFichasTotal-=1
	return ficha
	pass

func reiniciar():
	fichas = {"FichaI":28,"FichaL":28,"FichaT":28,"FichaCruz":18,"FichaDinamita":12,"FichaEntrada":9}
	pass
