extends Node2D

enum Cards {Bolt, GiftofFlame, LiftTheSky, TridentThrow, UndeadMarch}
enum StarterCards {SolarFlare, DawnsEmbrace, Sunburst}
#enum MonsterCards {Bolt, GiftofFlame, LiftTheSky, TridentThrow, UndeadMarch}

enum Resources {Money}
#enum MonsterResources {Money}

signal cardplayed
signal cardpicked
@onready var game_board = get_parent()

# this resourcemap is highkey useless
const ResourceMap = {
	"SolarFlare": Resources.Money,
	"Sunburst": Resources.Money,
	"DawnsEmbrace": Resources.Money,
	"Bolt": Resources.Money,
	"GiftofFlame": Resources.Money,
	"LiftTheSky": Resources.Money,
	"TridentThrow": Resources.Money,
	"UndeadMarch": Resources.Money,
}

const Cost = {
	"SolarFlare": 2,
	"Sunburst": 1,
	"DawnsEmbrace": 1,
	"Bolt": 2,
	"GiftofFlame": 1,
	"LiftTheSky": 4,
	"TridentThrow": 2,
	"UndeadMarch": 1,
}

const Power = {
	"SolarFlare": 3,
	"Sunburst": 3,
	"DawnsEmbrace": 0,
	"Bolt": 6,
	"GiftofFlame": 3,
	"LiftTheSky": 8,
	"TridentThrow": 4,
	"UndeadMarch": 2,
}

const Heal = {
	"SolarFlare": 0,
	"Sunburst": -1,
	"DawnsEmbrace": 2,
	"Bolt": -3,
	"GiftofFlame": 2,
	"LiftTheSky": -1,
	"TridentThrow": 0,
	"UndeadMarch": 0,
}

const ManaPerTurn = {
	"SolarFlare": 0,
	"Sunburst": 0,
	"DawnsEmbrace": 0,
	"Bolt": 0,
	"GiftofFlame": -1,
	"LiftTheSky": 2,
	"TridentThrow": 0,
	"UndeadMarch": 0,
}

const ContCard = {
	"SolarFlare": false,
	"Sunburst": true,
	"DawnsEmbrace": false,
	"Bolt": false,
	"GiftofFlame": false,
	"LiftTheSky": false,
	"TridentThrow": false,
	"UndeadMarch": false,
}

const Art = {
	"SolarFlare": "res://Art/StarterArt/solarflare.png",
	"Sunburst": "res://Art/StarterArt/sunburst.png",
	"DawnsEmbrace": "res://Art/StarterArt/dawnsembrace.png",
	"Bolt": "res://Art/CardArt/bolt.png",
	"GiftofFlame": "res://Art/CardArt/GiftofFlame.png",
	"LiftTheSky": "res://Art/CardArt/LiftTheSky.png",
	"TridentThrow": "res://Art/CardArt/tridentThrow.png",
	"UndeadMarch": "res://Art/CardArt/UndeadMarch.png",
	"Blank": "res://Art/CardArt/blank.png",
}

var sprite: Sprite2D
var area: Area2D
var card_type: String
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
	$Sprite2D.scale = Vector2(0.7,0.7)

func reveal():
	revealed = true

func get_card_type(card):
	return card.card_type

func _on_mouse_entered():
	$Sprite2D.scale = Vector2(0.8,0.8)
	$Sprite2D/AnimationPlayer.play("fade_in")

func _on_mouse_exited():
	$Sprite2D.scale = Vector2(0.7,0.7)
	$Sprite2D/AnimationPlayer.play_backwards("fade_in")
	
func _input_event(viewport, event, shape_idx):
	# continuous stuff
	if StateMachine.curstate == StateMachine.State.PLAYER1_PLAY:
			if event is InputEventMouseButton and event.pressed:
				if StateMachine.playermana >= Cost[self.card_type]:
					StateMachine.playermana -= Cost[self.card_type]
					print(Cost[self.card_type])
					print("click")
					print("monster loses", Power[self.card_type], "health")
					#print("prequeuefreetempdeck",StateMachine.tempdeck)
					print("prequeuefreerealdeck",StateMachine.truedeck)
					cardplayed.emit(self)
					#print("tempdeck",StateMachine.tempdeck)
					print("realdeck",StateMachine.truedeck)
					if ContCard[self.get_card_type(self)]:
						print("continuous")
						pass
					else:
						self.queue_free()
				else:
					print("you don't got enough to play this bro")
	elif StateMachine.curstate == StateMachine.State.END:
		if event is InputEventMouseButton and event.pressed:
			if StateMachine.pickCount > 0:
				#print("regdeckpreadd", StateMachine.deck)
				print("pre-add", StateMachine.truedeck)
				StateMachine.truedeck.append(self.card_type)
				StateMachine.pickCount -= 1
				if StateMachine.pickCount == 0:
					StateMachine.GameLevel += 1
					StateMachine.start_game(StateMachine.GameLevel)
					#print("regdeckpostadd", StateMachine.truedeck)
					print("post-add", StateMachine.truedeck)
				self.queue_free()
		pass

func _ready():
	area = $Sprite2D/Area2D
	area.input_event.connect(_input_event)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
