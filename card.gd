extends Node2D

enum Cards {Card1, Card2, Card3, Card4, Card5}

enum Resources {Money}

const ResourceMap = {
	Cards.Card1: Resources.Money,
	Cards.Card2: Resources.Money,
	Cards.Card3: Resources.Money,
	Cards.Card4: Resources.Money,
	Cards.Card5: Resources.Money,
}

const Power = {
	Cards.Card1: 1,
	Cards.Card2: 2,
	Cards.Card3: 3,
	Cards.Card4: 4,
	Cards.Card5: 5,
}
