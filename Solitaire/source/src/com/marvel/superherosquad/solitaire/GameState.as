package com.marvel.superherosquad.solitaire
{
	import as3cards.visual.CardPile;
	import as3cards.visual.VisualDeck;
	
	public class GameState
	{
		/*
		 * The klondike piles
		 */
		private var klondikePiles:Array;
		
		/*
		 * The ace piles
		 */
		private var acePiles:Array;
		
		/*
		 * The visual deck
		 */
		private var visualDeck:VisualDeck;
		
		/*
		 * The dealt pile
		 */
		private var dealtPile:CardPile;
		
		/*
		 * The id
		 */
		private var id:uint;
		
		/*
		 * The users current score
		 */
		private var score:uint;
		
		/*
		 * The number of times the user has cycled through the deck
		 */
		private var deckCycles:uint;
		
		/*
		private var ironManLocation:uint;
		private var hulkLocation:uint;
		private var captainAmericaLocation:uint;
		private var thorLocation:uint;
		private var wolverineLocation:uint;
		private var drDoomLocation:uint;
		private var msMarvelLocation:uint;
				
		private var bonusCards:Array;
		
		public function getBonusCards():Array {
			return this.bonusCards;
		}

		public function setBonusCards(bonusCards:Array):void {
			this.bonusCards = bonusCards;
		}
		
		public function getIronManLocation():uint {
			return this.ironManLocation;
		}

		public function setIronManLocation(ironManLocation:uint):void {
			this.ironManLocation = ironManLocation;
		}

		public function getHulkLocation():uint {
			return this.hulkLocation;
		}

		public function setHulkLocation(hulkLocation:uint):void {
			this.hulkLocation = hulkLocation;
		}

		public function getCaptainAmericaLocation():uint {
			return this.captainAmericaLocation;
		}

		public function setCaptainAmericaLocation(captainAmericaLocation:uint):void {
			this.captainAmericaLocation = captainAmericaLocation;
		}

		public function getThorLocation():uint {
			return this.thorLocation;
		}

		public function setThorLocation(thorLocation:uint):void {
			this.thorLocation = thorLocation;
		}

		public function getWolverineLocation():uint {
			return this.wolverineLocation;
		}

		public function setWolverineLocation(wolverineLocation:uint):void {
			this.wolverineLocation = wolverineLocation;
		}

		public function getDrDoomLocation():uint {
			return this.drDoomLocation;
		}

		public function setDrDoomLocation(drDoomLocation:uint):void {
			this.drDoomLocation = drDoomLocation;
		}

		public function getMsMarvelLocation():uint {
			return this.msMarvelLocation;
		}

		public function setMsMarvelLocation(msMarvelLocation:uint):void {
			this.msMarvelLocation = msMarvelLocation;
		}
*/
		public function getDeckCycles():uint {
			return this.deckCycles;
		}
		
		public function setDeckCycles(cycles:uint):void {
			this.deckCycles = cycles;
		}
		
		public function getScore():uint {
			return this.score;
		}
		
		public function setScore(score:uint):void {
			this.score = score;
		}
		
		public function getId():uint {
			return this.id;
		}
		
		public function setId(id:uint):void {
			this.id = id;
		}
		
		public function getKlondikePiles():Array {
			return this.klondikePiles;
		}

		public function setKlondikePiles(klondikePiles:Array):void {
			this.klondikePiles = klondikePiles;
		}

		public function getAcePiles():Array {
			return this.acePiles;
		}

		public function setAcePiles(acePiles:Array):void {
			this.acePiles = acePiles;
		}

		public function getVisualDeck():VisualDeck {
			return this.visualDeck;
		}

		public function setVisualDeck(visualDeck:VisualDeck):void {
			this.visualDeck = visualDeck;
		}
		
		public function setDealtPile(dealtPile:CardPile):void {
			this.dealtPile = dealtPile;
		}
		
		public function getDealtPile():CardPile {
			return this.dealtPile;
		}
	}
}