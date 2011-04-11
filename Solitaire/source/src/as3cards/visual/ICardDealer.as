package as3cards.visual
{
	public interface ICardDealer
	{
		function deal():VisualCard
		function getCardOnTop():VisualCard;
		function reset():void;
		function setDeck(vd:VisualDeck):void;
		function setDealtPile(pile:CardPile):void;
	}
}