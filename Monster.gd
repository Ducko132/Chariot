extends Node2D

enum Monsters{Cyclops, Minotaur, Hydra, Ares, Hermes}
var timer
@onready var game_board = get_parent()
#signal animationFinished

#const Art = {
#	"Cyclops": "res://Art/MonsterArt/Cyclops/CyclopsIdle1.png",
#}
func hplost():
	$AnimatedSprite2D.play("cyclops_damage")
	print("hp lost")
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("cyclops_idle")

func _ready():
	print("ready")
	game_board.monsterhplost.connect(hplost)
	$AnimatedSprite2D.play("cyclops_idle")

func _process(delta):
	#if StateMachine.monsterhp
	pass

func reganimation():
	pass
	#$AnimatedSprite2D.play("cyclops_idle")

#func _on_animated_sprite_2d_animation_changed():
	#$AnimatedSprite2D.play("cyclops_damage")
	#print("animation changed")
	#$AnimatedSprite2D.play("cyclops_idle")
	#pass # Replace with function body.
