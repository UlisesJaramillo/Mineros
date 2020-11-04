extends Camera2D

export var velocidad = 15.0
onready var tweenNode = $Tween

export var zoomspeed = 10.0

export var zoomMin = 0.25
export var zoomMax = 4.0

var zoomfactor = 1.0
var zooming = false

var posAnterior

onready var posCamaraAnterior=get_global_mouse_position()
var posCamaraActual
var arrastre
var habilitado=false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func habilitar():
	habilitado=true
	pass
	
func desHablitar():
	habilitado=false
	pass
func _input(event):
	if habilitado:
		if event is InputEventMouseButton:
			if event.is_pressed():
				zooming = true
				if event.button_index == BUTTON_WHEEL_UP:
					zoomfactor -= 0.01 * zoomspeed
				if event.button_index == BUTTON_WHEEL_DOWN:
					zoomfactor += 0.01 * zoomspeed
					
			else:
				zooming = false
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
			if not arrastre:
				arrastre = true
			
			else:
				arrastre = false
func _physics_process(delta):
	if habilitado:
################################################movimiento de camara con teclado
		var inputX = (int(Input.is_action_pressed("mover_derecha"))- int(Input.is_action_pressed("mover_izquierda")))
		var inputY = (int(Input.is_action_pressed("mover_abajo"))- int(Input.is_action_pressed("mover_arriba")))
		
		position.x = lerp(position.x,position.x + inputX * velocidad , velocidad * delta)
		position.y = lerp(position.y,position.y + inputY * velocidad , velocidad * delta)
		
	#####################################################zoom
		zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
		zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
		
		zoom.x = clamp(zoom.x, zoomMin, zoomMax)
		zoom.y = clamp(zoom.y, zoomMin, zoomMax)
		
		if not zooming:
			zoomfactor = 1.0
			
	#####################################################movimiento de camara con mouse
		posCamaraActual = get_viewport().get_mouse_position()
		if arrastre:
			var diff = posCamaraAnterior - posCamaraActual
			translate(diff)
		posCamaraAnterior = posCamaraActual
		
		if Input.is_action_just_pressed("retornar"):
			var aux = self.position
			tweenNode.interpolate_property(self,"position",self.position,posAnterior,1.0,Tween.TRANS_EXPO,Tween.EASE_OUT)
			tweenNode.start()
			posAnterior=aux
