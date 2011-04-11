package com.marvel.superherosquad.solitaire
{
	import as3cards.core.Card;
	import as3cards.core.CardValue;
	import as3cards.core.Deck;
	import as3cards.core.Suit;
	import as3cards.visual.ISkinCreator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.filters.DropShadowFilter;
	
	import mx.core.BitmapAsset;
	

	public class GlymetrixWesternSkin implements ISkinCreator
	{
	
	[Embed(source="../../../../../artwork/board/foundation-slot.swf")]
	private var EmptyPile:Class; 
	
	[Embed(source="../../../../../artwork/board/king-slot.swf")]
	private var EmptyKingPile:Class;

	[Embed(source="../../../../../artwork/board/draw-deck-slot.png")]
	private var Deck:Class;
	
	[Embed(source="../../../../../artwork/board/draw-deck-slot-empty.png")]
	private var DeckEmpty:Class;
		
	
	[Embed(source="../../../../../artwork/cards/two_clubs.png")]
	private var TwoClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/two_diamonds.png")]
	private var TwoDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/two_hearts.png")]
	private var TwoHearts:Class;

	[Embed(source="../../../../../artwork/cards/two_spades.png")]
	private var TwoSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/three_clubs.png")]
	private var ThreeClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/three_diamonds.png")]
	private var ThreeDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/three_hearts.png")]
	private var ThreeHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/three_spades.png")]
	private var ThreeSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/four_clubs.png")]
	private var FourClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/four_diamonds.png")]
	private var FourDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/four_hearts.png")]
	private var FourHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/four_spades.png")]
	private var FourSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/five_clubs.png")]
	private var FiveClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/five_diamonds.png")]
	private var FiveDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/five_hearts.png")]
	private var FiveHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/five_spades.png")]
	private var FiveSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/six_clubs.png")]
	private var SixClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/six_diamonds.png")]
	private var SixDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/six_hearts.png")]
	private var SixHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/six_spades.png")]
	private var SixSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/seven_clubs.png")]
	private var SevenClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/seven_diamonds.png")]
	private var SevenDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/seven_hearts.png")]
	private var SevenHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/seven_spades.png")]
	private var SevenSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/eight_clubs.png")]
	private var EightClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/eight_diamonds.png")]
	private var EightDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/eight_hearts.png")]
	private var EightHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/eight_spades.png")]
	private var EightSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/nine_clubs.png")]
	private var NineClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/nine_diamonds.png")]
	private var NineDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/nine_hearts.png")]
	private var NineHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/nine_spades.png")]
	private var NineSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/ten_clubs.png")]
	private var TenClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/ten_diamonds.png")]
	private var TenDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/ten_hearts.png")]
	private var TenHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/ten_spades.png")]
	private var TenSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/jack_clubs.png")]
	private var JackClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/jack_diamonds.png")]
	private var JackDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/jack_hearts.png")]
	private var JackHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/jack_spades.png")]
	private var JackSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/queen_clubs.png")]
	private var QueenClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/queen_diamonds.png")]
	private var QueenDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/queen_hearts.png")]
	private var QueenHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/queen_spades.png")]
	private var QueenSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/king_clubs.png")]
	private var KingClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/king_diamonds.png")]
	private var KingDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/king_hearts.png")]
	private var KingHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/king_spades.png")]
	private var KingSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/ace_clubs.png")]
	private var AceClubs:Class;
	
	[Embed(source="../../../../../artwork/cards/ace_diamonds.png")]
	private var AceDiamonds:Class;
	
	[Embed(source="../../../../../artwork/cards/ace_hearts.png")]
	private var AceHearts:Class;
	
	[Embed(source="../../../../../artwork/cards/ace_spades.png")]
	private var AceSpades:Class;
	
	[Embed(source="../../../../../artwork/cards/backcard.png")]
	private var GlymetrixCardBack:Class;
		
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
				//var dropShadow:DropShadowFilter = new DropShadowFilter( 6, 45, 0x000000, .7, 7, 7 );
				//_dragFilters.push( dropShadow );
			}
		}

		public function createDeck():DisplayObject
		{
			return new GlymetrixCardBack();
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
			if (dealAgain) {
				return new Deck();
			}
			else {
				return new DeckEmpty();
			}
		}
		
		public function createEmptyAce():DisplayObject
		{
			return new EmptyPile();
		}
		
		public function createEmptyKing():DisplayObject
		{
			return new EmptyKingPile();
		}

		public function get dragFilters():Array
		{		
			return _dragFilters;
		}
	}
}