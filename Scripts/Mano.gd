extends Node

# esta clase sirve para mantener las fichas en la "mano" del jugador, maneja un diccionario con los tipos de fichas y sus cantidades.



#METODOS:
#sacarFicha(String):String saca una ficha a elección
#ponerFicha(String):boolean pone una ficha en la coleccion
#recorrido():String un metodo para recorrer las fichas en la mano y sus cantidades


#////////////////////////////////////////////////////////////////////
#VARIABLES

var fichas = {"FichaI":0,"FichaL":0,"FichaT":0,"FichaCruz":0,"FichaDinamita":0,"FichaEntrada":0}

#/////////////////////////////////////////////////////////////////////
#METODOS


func _init():
	pass
	
func sacarFicha(ficha):
	fichas[ficha] -=1
	pass
	
func ponerFicha(ficha):
	fichas[ficha] +=1
	pass
func getMano():
	return fichas
func getCantFichas():
	return fichas["FichaI"]+fichas["FichaL"]+fichas["FichaT"]+fichas["FichaCruz"]+fichas["FichaDinamita"]+fichas["FichaEntrada"]
	
