extends Node2D

enum Monsters{Cyclops, Minotaur, Hydra, Ares, Hermes}
var timer
#signal animationFinished

#const Art = {
#	"Cyclops": "res://Art/MonsterArt/Cyclops/CyclopsIdle1.png",
#}
func _ready():
	StateMachine.monsterhplost.connect(hplost)
	$AnimatedSprite2D.play("cyclops_idle")

func _process(delta):
	#if StateMachine.monsterhp
	pass

func hplost():
	$AnimatedSprite2D.play("cyclops_damage")
	print("animationplayed")
	await(OS.delay_usec(int(2*1000000)))
	reganimation()

func reganimation():
	$AnimatedSprite2D.play("cyclops_idle")

func _on_animated_sprite_2d_animation_changed():
	#$AnimatedSprite2D.play("cyclops_damage")
	print("animation changed")
	#$AnimatedSprite2D.play("cyclops_idle")
	pass # Replace with function body.
