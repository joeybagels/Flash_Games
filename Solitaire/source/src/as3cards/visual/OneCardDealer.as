package as3cards.visual
{
	import flash.display.DisplayObject;
	
	public class OneCardDealer extends AbstractCardDealer
	{

		public function OneCardDealer(deck:VisualDeck, pile:CardPile)
		{
			super(deck, pile);
		}

		override public function deal():VisualCard
		{
			var card:VisualCard = new VisualCard( deck.deal( false ), false );
					
			// Add the card to the dealt pile
			pile.addCard( card );
			
			return card;
		}
	}
}