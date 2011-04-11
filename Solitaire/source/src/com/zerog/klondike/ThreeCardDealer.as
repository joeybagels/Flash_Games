package com.zerog.klondike
{
	import flash.display.DisplayObject;
	
	import as3cards.visual.AbstractCardDealer;
	import as3cards.visual.VisualCard;
	import as3cards.visual.VisualDeck;
	import as3cards.visual.CardPile;
	
	public class ThreeCardDealer extends AbstractCardDealer
	{
		
		public function ThreeCardDealer(deck:VisualDeck, pile:CardPile)
		{
			super(deck, pile);
		}

		override public function deal():VisualCard
		{
			var card:VisualCard;
			
			//if there are cards on the table, consolidate them
			//placing them on top of each other aligned with the bottom
			//visual card
			var init:Boolean = false;
			var baseX:Number = 0;
			var baseY:Number = 0;
			for (var i:uint = 0; i < pile.numChildren; i++) {
				card = pile.getChildAt(i) as VisualCard;
				
				if (card != null) {
					//if not inited, init it
					if (!init) {
						init = true;
						baseX = card.x;
						baseY = card.y;
						//trace("base is " + baseX + "," + baseY);
					}
					//if its been inited
					else {
						card.x = baseX;
						card.y = baseY;
						
						//trace("moved card back to " + baseX + "," + baseY);
					}
				}
			}
			
			
			//now deal three cards
			if (!deck.isEmpty()) {
				card = new VisualCard( deck.deal( false ), false );
					
				// Add the card to the dealt pile
				pile.addCard( card );
				
				//re-adjust back to base
				card.x = baseX;
				card.y = baseY;
				
				if (!deck.isEmpty()) {
					card = new VisualCard( deck.deal( false ), false );
					
					// Add the card to the dealt pile
					pile.addCard( card );
				
					if (!deck.isEmpty()) {
						card = new VisualCard( deck.deal( false ), false );
							
						// Add the card to the dealt pile
						pile.addCard( card );
					}
				}	
			}

			return card;
		}
	}
}