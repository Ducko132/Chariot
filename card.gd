extends Node2D

enum Cards {Bolt, GiftofFlame, LiftTheSky, TridentThrow, UndeadMarch}

enum Resources {Money}

const ResourceMap = {
	Cards.Bolt: Resources.Money,
	Cards.GiftofFlame: Resources.Money,
	Cards.LiftTheSky: Resources.Money,
	Cards.TridentThrow: Resources.Money,
	Cards.UndeadMarch: Resources.Money,
}

const Power = {
	Cards.Bolt: 6,
	Cards.GiftofFlame: 3,
	Cards.LiftTheSky: 8,
	Cards.TridentThrow: 4,
	Cards.UndeadMarch: 2,
}

const Art = {
	Cards.Bolt: "res://Art/bolt.png",
	Cards.TridentThrow: "res://Art/tridentThrow.png",
	Cards.UndeadMarch: "res://Art/UndeadMarch.png",
	Cards.LiftTheSky: "res://Art/LiftTheSky.png",
	Cards.GiftofFlame: "res://Art/GiftofFlame.png",
}
