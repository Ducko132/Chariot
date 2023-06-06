extends Node2D

enum Monsters{Cyclops, Minotaur, Hydra, Ares, Hermes}
var timer
var monstertype = null
@onready var game_board = get_parent()

func hplost():
	$AnimatedSprite2D.play("tutorialdummydamage")
	print("hp lost")
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("tutorialdummyidle")

func _ready():
	print("ready")
	game_board.monsterhplost.connect(hplost)
	$AnimatedSprite2D.play("tutorialdummyidle")

func _process(delta):
	if StateMachine.curstate == StateMachine.State.END:
		pass
	if StateMachine.curstate == StateMachine.State.MONSTERTURN:
		await get_tree().create_timer(0.5).timeout
		$AniamtedSprite2D.play("tutorialdummyidle")
