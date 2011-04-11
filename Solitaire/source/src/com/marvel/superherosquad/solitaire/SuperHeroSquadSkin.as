package com.marvel.superherosquad.solitaire
{
	import as3cards.core.Card;
	import as3cards.core.CardValue;
	import as3cards.core.Suit;
	import as3cards.visual.ISkinCreator;
	
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	
	import mx.core.BitmapAsset;
	
	
	public class AbstractSuperHeroSquadSkin implements ISkinCreator
	{
	
	[Embed(source="../../../../../artwork/board/foundation-slot.swf")]
	private var EmptyPile:Class;
	
	[Embed(source="../../../../../artwork/board/draw-deck-slot.png")]
	private var DeckEmpty:Class;
		
	[Embed(source="../../../../../artwork/cards/wolverine.png")]
	private var CardBack:Class;
	
	[Embed(source="../../../../../artwork/cards/2-c.png")]
	private var TwoClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/2-d.png")]
	private var TwoDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/2-h.png")]
	private var TwoHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/2-s.png")]
	private var TwoSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/3-c.png")]
	private var ThreeClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/3-d.png")]
	private var ThreeDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/3-h.png")]
	private var ThreeHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/3-s.png")]
	private var ThreeSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/4-c.png")]
	private var FourClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/4-d.png")]
	private var FourDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/4-h.png")]
	private var FourHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/4-s.png")]
	private var FourSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/5-c.png")]
	private var FiveClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/5-d.png")]
	private var FiveDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/5-h.png")]
	private var FiveHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/5-s.png")]
	private var FiveSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/6-c.png")]
	private var SixClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/6-d.png")]
	private var SixDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/6-h.png")]
	private var SixHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/6-s.png")]
	private var SixSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/7-c.png")]
	private var SevenClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/7-d.png")]
	private var SevenDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/7-h.png")]
	private var SevenHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/7-s.png")]
	private var SevenSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/8-c.png")]
	private var EightClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/8-d.png")]
	private var EightDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/8-h.png")]
	private var EightHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/8-s.png")]
	private var EightSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/9-c.png")]
	private var NineClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/9-d.png")]
	private var NineDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/9-h.png")]
	private var NineHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/9-s.png")]
	private var NineSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/10-c.png")]
	private var TenClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/10-d.png")]
	private var TenDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/10-h.png")]
	private var TenHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/10-s.png")]
	private var TenSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/j-c.png")]
	private var JackClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/j-d.png")]
	private var JackDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/j-h.png")]
	private var JackHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/j-s.png")]
	private var JackSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/q-c.png")]
	private var QueenClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/q-d.png")]
	private var QueenDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/q-h.png")]
	private var QueenHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/q-s.png")]
	private var QueenSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/k-c.png")]
	private var KingClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/k-d.png")]
	private var KingDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/k-h.png")]
	private var KingHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/k-s.png")]
	private var KingSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/a-c.png")]
	private var AceClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/a-d.png")]
	private var AceDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/a-h.png")]
	private var AceHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/a-s.png")]
	private var AceSpades:Class;
	
	/** 
	 * A list of the filters that are applied to a display object
	 * when it is dragged.
	 */
	private var _dragFilters:Array;
	
		public function GlymetrixWesternSkin()
		{
			// Create the array if it hasn't been made yet
			if ( _dragFilters == null )
			{
				_dragFilters = new Array();

				// Apply a drop shadow for depth (so the object looks like it's
				// been picked up)
				var dropShadow:DropShadowFilter = new DropShadowFilter( 6, 45, 0x000000, .7, 7, 7 );
				_dragFilters.push( dropShadow );
			}
		}

		public function createDeck():DisplayObject
		{
			return new CardBack();
		}
		
		public function createCard(card:Card):DisplayObject
		{
			var clazz:Class = this[ CardValue.getName( card.value )
									+ Suit.getName( card.suit ) ];
		
			var s:BitmapAsset = new clazz();

			return s;
		}
		
		public function createCycleDeck(dealAgain:Boolean):DisplayObject
		{
			return new DeckEmpty();
		}
		
		public function createEmptyAce():DisplayObject
		{
			return new EmptyPile();
		}
		
		public function createEmptyKing():DisplayObject
		{
			return new EmptyPile();
		}
		
		public function get dragFilters():Array
		{		
			return _dragFilters;
		}
		
	}
}