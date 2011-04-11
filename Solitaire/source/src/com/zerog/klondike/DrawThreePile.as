package com.zerog.klondike
{
	import as3cards.visual.CardPile;
	import as3cards.visual.SpreadingDirection;
	import as3cards.visual.VisualCard;	

	public class DrawThreePile extends CardPile
	{
		public function DrawThreePile()
		{
			super( null, SpreadingDirection.EAST );
		}

		/**
		 * You can not manually add cards to the card pile
		 */
		public override function canAdd( cardPile:CardPile ):Boolean
		{
			return false;
		}
		
		/**
		 * When a card is added, the face of the card needs to be showing
		 */
		public override function addCard( card:VisualCard ):void
		{
			// Make sure the card is face up when added to the dealt pile
			card.isDown = false;
			
			super.addCard( card );
		}
		
		override public function copy():CardPile {
			//make a new kpile
			var cPile:DrawThreePile = new DrawThreePile();
			cPile.x = this.x;
			cPile.y = this.y;
								
			var vc:VisualCard = null;
			
			//for each card in the current kpile
			for (var i:uint = 0; i < this.numChildren; i++) {
				vc = getChildAt(i) as VisualCard;
				if (vc != null) {			
					var vc2:VisualCard = new VisualCard(vc.card.copy(), vc.isDown);
					
					//push it into the new kpile
					cPile.addCard(vc2);
					
					//restore x and y because a three card pile does is sometimes stacked
					//with a spread and sometimes not and we cannot rely on addCard function to
					//know all the time
					vc2.x = vc.x;
					vc2.y = vc.y;

				}
			}
						
			return cPile;
		}
	}
}