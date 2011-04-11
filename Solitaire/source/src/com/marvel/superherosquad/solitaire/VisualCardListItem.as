package com.marvel.superherosquad.solitaire
{
	import as3cards.core.Card;
	import as3cards.visual.SkinManager;
	
	import com.zerog.components.list.AbstractListItem;

	public class VisualCardListItem extends AbstractListItem
	{
		private var card:Card;
		
		public function VisualCardListItem(card:Card)
		{
			super();
			
			this.card = card;
			
			addChild(SkinManager.skinCreator.createCard(card));
		}
	}
}