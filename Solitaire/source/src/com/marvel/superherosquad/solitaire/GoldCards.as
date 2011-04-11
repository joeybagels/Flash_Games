package com.marvel.superherosquad.solitaire
{
	import as3cards.core.Suit;
	
	import flash.display.MovieClip;
	
	public class GoldCards extends MovieClip implements IGoldCard
	{
		public var coins:MovieClip;
		public var heart:MovieClip;
		public var diamond:MovieClip;
		public var spade:MovieClip;
		public var club:MovieClip;
		private var suitToShow:int;
		public function GoldCards()
		{
			super();
			
			gotoAndStop(1);
			this.coins.gotoAndStop(1);
			reset();
		}
		public function reset():void {
			this.coins.visible = false;
			this.heart.visible = false;
			this.diamond.visible = false;
			this.club.visible = false;
			this.spade.visible = false;
		}
		public function showSuit(suit:int):void {
			this.suitToShow = suit;
			
			play();
		}
		
		public function dropCoins():void {
			this.coins.visible = true;
			this.coins.gotoAndPlay(1);
		}
		
		private function showCard():void {
			switch(this.suitToShow) {
				case Suit.HEARTS:
					this.heart.visible = true;
					break;
				case Suit.CLUBS:
					this.club.visible = true;
					break;
				case Suit.DIAMONDS:
					this.diamond.visible = true;
					break;
				case Suit.SPADES:
					this.spade.visible = true;
					break;
			}
		}
	}
}