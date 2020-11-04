extends Node2D

onready var tex_I = preload("res://Texturas/fichaI.png")
onready var tex_L = preload("res://Texturas/fichaL.png")
onready var tex_T = preload("res://Texturas/fichaT.png")
onready var tex_Cruz = preload("res://Texturas/fichaCruz.png")
onready var tex_Entrada = preload("res://Texturas/fichaEntrada.png")
onready var tex_Dinamita = preload("res://Texturas/fichaDinamita.png")

var tipoFicha
var rotacion=0
func _ready():
	pass # Replace with function body.


func rotar():
	rotacion=int($Imagen.rotation_degrees + 90) % 360
	$Imagen.rotation_degrees = int($Imagen.rotation_degrees + 90) % 360
	
	pass


func ponerImagen(tipo):
	if tipo == "FichaI":
		$Imagen.texture = tex_I
		tipoFicha = "FichaI"
	elif tipo == "FichaL":
		$Imagen.texture = tex_L
		tipoFicha = "FichaL"
	elif tipo == "FichaT":
		$Imagen.texture = tex_T
		tipoFicha = "FichaT"
	elif tipo == "FichaCruz":
		$Imagen.texture = tex_Cruz
		tipoFicha = "FichaCruz"
	elif tipo == "FichaEntrada":
		$Imagen.texture = tex_Entrada
		tipoFicha = "FichaEntrada"
	elif tipo == "FichaDinamita":
		$Imagen.texture = tex_Dinamita
		tipoFicha = "FichaDinamita"
	pass
	
func getTipo():
	return tipoFicha
func getRotacion():
	return rotacion
	pass
