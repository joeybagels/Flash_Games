package as3cards.visual
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	
	public class AbstractCardDealer implements ICardDealer
	{
		protected var pile:CardPile;
		protected var deck:VisualDeck;
		
		public function AbstractCardDealer(deck:VisualDeck, pile:CardPile)
		{
			this.deck = deck;
			this.pile = pile;
		}
		public function setDealtPile(pile:CardPile):void {
			this.pile = pile;
		}
		public function setDeck(vd:VisualDeck):void {
			this.deck = vd;
		}
		public function deal():VisualCard
		{
			throw new IllegalOperationError("Function not implemented");
		}
		
		public function getCardOnTop():VisualCard {
			if (pile.numChildren > 0) {	
				var dObject:DisplayObject = pile.getChildAt(pile.numChildren - 1);
				
				return dObject as VisualCard;
			}
			else {
				return null;
			}
		}
		
		public function reset():void {
			// Bring the deal cards back into the deck to deal them again
			this.deck.reset();
			
			// Remove everything from the dealtPile
			while ( pile.numChildren != 0 )
			{
				pile.removeChildAt( 0 );
			}
		}
	}
}