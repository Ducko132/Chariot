extends Node2D

enum Cards {Bolt, GiftofFlame, LiftTheSky, TridentThrow, UndeadMarch}
enum MonsterCards {Bolt, GiftofFlame, LiftTheSky, TridentThrow, UndeadMarch}

enum Resources {Money}
enum MonsterResources {Money}

signal cardplayed

const ResourceMap = {
	"Bolt": Resources.Money,
	"GiftofFlame": Resources.Money,
	"LiftTheSky": Resources.Money,
	"TridentThrow": Resources.Money,
	"UndeadMarch": Resources.Money,
}

const Cost = {
	"Bolt": 3,
	"GiftofFlame": 1,
	"LiftTheSky": 4,
	"TridentThrow": 2,
	"UndeadMarch": 1,
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
	"Blank": "res://Art/blank.png",
}

var sprite: Sprite2D
var area: Area2D
var card_type
var revealed = false
var SpriteTexture

func set_card_type(type):
	card_type = type
	print("type",card_type)
	var texture = load(Art[card_type])
	#$Sprite2D.texture = texture 
	SpriteTexture = texture
	if !revealed:
		$Sprite2D.texture = load(Art["Blank"])
	else:
		$Sprite2D.texture = texture 
	$Sprite2D.scale = Vector2(0.3,0.3)

func reveal():
	revealed = true

func get_card_type(card):
	return card.card_type

func _on_mouse_entered():
	$Sprite2D.scale = Vector2(0.5,0.5)

func _on_mouse_exited():
	$Sprite2D.scale = Vector2(0.3,0.3)
	
func _input_event(viewport, event, shape_idx):
	if StateMachine.curstate == StateMachine.State.PLAYER1_PLAY:
			if event is InputEventMouseButton and event.pressed:
				if StateMachine.playermana >= Cost[self.card_type]:
					StateMachine.playermana -= Cost[self.card_type]
					print(Cost[self.card_type])
					print("click")
					print("monster loses", Power[self.card_type], "health")
					cardplayed.emit(self)
					self.queue_free()
				else:
					print("you don't got enough to play this bro")

func _ready():
	area = $Sprite2D/Area2D
	area.input_event.connect(_input_event)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
