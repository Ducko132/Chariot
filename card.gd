extends Node2D

enum Cards {Bolt, GiftofFlame, LiftTheSky, TridentThrow, UndeadMarch}

enum Resources {Money}

const ResourceMap = {
	"Bolt": Resources.Money,
	"GiftofFlame": Resources.Money,
	"LiftTheSky": Resources.Money,
	"TridentThrow": Resources.Money,
	"UndeadMarch": Resources.Money,
}

const Power = {
	"Bolt": 6,
	"GiftofFlame": 3,
	"LiftTheSky": 8,
	"TridentThrow": 4,
	"UndeadMarch": 2,
}

const Art = {
	"Bolt": "res://Art/bolt.png",
	"GiftofFlame": "res://Art/GiftofFlame.png",
	"LiftTheSky": "res://Art/LiftTheSky.png",
	"TridentThrow": "res://Art/tridentThrow.png",
	"UndeadMarch": "res://Art/UndeadMarch.png",
}

var sprite: Sprite2D
var area: Area2D
var card_type

func set_card_type(type):
	card_type = type
	print("type",card_type)
	var texture = load(Art[card_type])
	$Sprite2D.texture = texture 
	$Sprite2D.scale = Vector2(0.3,0.3)

func _on_mouse_entered():
	$Sprite2D.scale = Vector2(0.5,0.5)
	print("mouse in")
	pass

func _on_mouse_exited():
	$Sprite2D.scale = Vector2(0.3,0.3)
	print("mouse gone")
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("click")
		print(self.name)
		print("power", Power[self.card_type])

func _ready():
	area = $Sprite2D/Area2D
	area.input_event.connect(_input_event)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	
	#set_card_type("Bolt")
