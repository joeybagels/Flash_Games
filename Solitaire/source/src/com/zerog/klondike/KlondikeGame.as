/*
 * Copyright (c) 2007 Darron Schall
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package com.zerog.klondike
{
	
import as3cards.core.DeckType;
import as3cards.visual.CardEvent;
import as3cards.visual.CardPile;
import as3cards.visual.ICardDealer;
import as3cards.visual.OneCardDealer;
import as3cards.visual.SkinManager;
import as3cards.visual.SpreadingDirection;
import as3cards.visual.VisualCard;
import as3cards.visual.VisualDeck;

import com.zerog.utils.geom.Position;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import gs.TweenLite;

/**
 * 
 */
public class KlondikeGame extends Sprite
{
	public static const DECK_TO_KLONDIKE_PILE:String = "deck to klondike";
	public static const TO_ACE_PILE:String = "to ace pile";
	public static const ACE_PILE_TO_KLONDIKE_PILE:String = "ace to klondike";
	public static const KLONDIKE_PILE_TO_KLONDIKE_PILE:String = "klondike to klondike";
	
	protected static const DRAW_ONE:int = 1;
	protected static const DRAW_THREE:int = 2;
	
	protected var visualDeck:VisualDeck;
	protected var dealtPile:CardPile;		// could be DealOnePile or DealThreePile
	
	/*
	 * An array of <code>KlondikePile</code> objects
	 */
	protected var klondikePiles:Array;
	protected var acePiles:Array;
	
	// For drag and drop support
	//protected var draggingPile:CardPile;
	//private var originatingPile:CardPile;
	
	//private var numDraggingChildren:uint = 0;
	protected var cardDealer:ICardDealer;
	
	/**
	 * Default to draw one
	 */
	protected var drawType:int = DRAW_ONE;
	
	
	/**
	 * Constructor
	 */
	public function KlondikeGame(bg:DisplayObject = null)
	{
		//newGame(bg);
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		//addEventListener( MouseEvent.MOUSE_UP, checkDrop );
	}
	protected function onAddedToStage(e:Event):void {
		this.stage.addEventListener(MouseEvent.MOUSE_UP, onStageClick, true);
	}
	
	private function cleanUpDragging():void {
		trace("clean up draggign");
		if (this.pileBeingDragged != null) {
			trace("dragging not null " + this.pileBeingDragged);
			//get the top card
			var vc:VisualCard = this.pileBeingDragged.getTopCard();
				
			if (vc != null) {
				trace("top card not null " + vc);
				trace(vc.originatingCardPile);
				moveBack(vc.originatingCardPile, this.pileBeingDragged);
			}
		}
		
		if (this.clickedCard != null) {
			this.clickedCard.removeEventListener(MouseEvent.MOUSE_MOVE, dragStart);
			this.clickedCard = null;
		}
		
		setupListeners(true);
	}
	
	protected function onStageClick(e:MouseEvent):void {
		trace("ON STAGE CLICK");
		//get the objs under the mouse
		var dropObjs:Array = this.stage.getObjectsUnderPoint( new Point( e.stageX, e.stageY ) );
		
		//if top is a visual card
		var o:DisplayObject = dropObjs[dropObjs.length - 1] as DisplayObject;
		var vc:VisualCard = getDescendantByClass(o, VisualCard) as VisualCard;
		
		if (vc != null) {
			vc.removeEventListener(MouseEvent.MOUSE_MOVE, dragStart);
			checkDrop(e);
		}
		else {
			//if clicked not on visual card
			//if dragging pile exists, move it back
			cleanUpDragging();
		}
	}
	
	override public function get width():Number {
			return 760;
	}

	override public function get height():Number {
		return 610;
	}
		
	/**
	 * Constructs a new game of Klondike
	 */
	public function newGame(bg:DisplayObject = null):void
	{
		cleanUp();
		
		if (bg != null) {
			addChild(bg);
		}
		
		createBoard();
		dealCards();
		setupListeners();
	}
	
	/**
	 * Removes all of visual elements so that they can be
	 * garbage collected, and gives us a "clean slate" to 
	 * create the game board
	 */
	private function cleanUp():void
	{
		while ( numChildren > 0 )
		{
			removeChildAt( 0 );
		}
	}

	//protected function onCardPileAdd(e:Event):void {
		
	//}
	
	/**
	 * Creates the initial layout for the game, sets up the
	 * card piles but does not deal.
	 */
	protected function createBoard():void
	{
		// TODO: Get board dimensions from a style manager?
		visualDeck = new VisualDeck( DeckType.WITHOUT_JOKERS );
		visualDeck.x = 0;
		visualDeck.y = 0;
		visualDeck.buttonMode = true;
		
		// TODO: Use a factory to get the dealtPile based on the
		// user's deal settings (deal one vs. deal three)
		if (drawType == DRAW_THREE) {
			dealtPile = new DrawThreePile();
			cardDealer = new ThreeCardDealer(visualDeck, dealtPile);
		}
		else if (drawType == DRAW_ONE) {
			dealtPile = new DrawOnePile();
			cardDealer = new OneCardDealer(visualDeck, dealtPile);	
		}
		
		dealtPile.x = 90;
		dealtPile.y = 0;
		addChild( dealtPile );
		//dealtPile.addEventListener(CardPile.ADD_CARD, onCardPileAdd);
		
		acePiles = new Array();
		curX = 90*3;
		curY = 0;

		// There are 4 Ace piles to create
		for ( i = 0; i < 4; i++ )
		{
			var ap:AcePile = new AcePile();
			ap.x = curX;
			ap.y = curY;
			// Save the reference
			acePiles.push( ap );
			// Add the pile to the screen
			addChild( ap );
			// Move the next pile 90 to the right
			curX += 90;
		}
		
		// Store references to the Klondike piles
		klondikePiles = new Array();
		var curX:int = 0;
		var curY:int = 100;
		// There are 7 Klondike piles to create
		for ( var i:int = 0; i < 7; i++ )
		{
			var kp:KlondikePile = new KlondikePile();
		//	kp.addEventListener(CardPile.ADD_CARD, onCardPileAdd);
			kp.x = curX;
			kp.y = curY;
			// Saves the reference
			klondikePiles.push( kp );
			// Add the pile to the screen
			addChild( kp );
			// Move the next pile 90 to the right
			curX += 90;
		}
		

		addChild( visualDeck );
	}

	/**
	 * Deals the cards from the deck into the klondike piles
	 */
	private function dealCards():void
	{
		// First, shuffle the deck
		visualDeck.shuffle();
		var init:Boolean = false;
		
		// Deal rows horizontally
		for ( var i:int = 0; i < 7; i++ )
		{
			//move off screen invisible
			//klondikePiles[i].x = this.width;
			//klondikePiles[i].y = this.height;
			
			//klondikePiles[i].visible = false;
			
			var card:VisualCard = new VisualCard( visualDeck.deal(), false );
			card.visible = false;
			// Flip over the first card, deal the rest face down
			//var card:VisualCard = new VisualCard( visualDeck.deal(), false );
			
			// Set up the card for drag and drop
			//configureDrag( card );
			
			// Add the card to the pile
			klondikePiles[i].addCard( card );
			
			// Add face down cards to all of the card piles on the right of this one
			for ( var j:int = i + 1; j < 7; j++ )
			{
				card = new VisualCard( visualDeck.deal(), true );
				card.visible = false;
				klondikePiles[j].addCard( card );
			}
		}
		
		var count:int = 0;
		for (i = 0; i < 7; i++) 
		{
			var kp:KlondikePile = klondikePiles[i] as KlondikePile;
			
			for (j = 0; j < kp.numChildren; j++) { 
				count++;
			
				card = kp.getChildAt(j) as VisualCard;
				
				var oldX:Number = card.x;
				var oldY:Number = card.y;
				
				//var offScreen:Point = getRandomEdgePoint(card);
				var globalCardPoint:Point = Position.getGlobal(card);
				var globalVisualDeckPoint:Point = Position.getGlobal(this.visualDeck);
				
				//find the offsent
				var xOffset:Number = globalCardPoint.x - globalVisualDeckPoint.x;
				var yOffset:Number = globalCardPoint.y - globalVisualDeckPoint.y;
				
				
				card.x -= xOffset;
				card.y -= yOffset;
				card.visible = true;
				
				TweenLite.delayedCall((count - 1)*.05, dealCardsMove, new Array(card, oldX, oldY, count));
				
			}
		}
	}
	
	private function dealCardsMove(card:VisualCard, oldX:Number, oldY:Number, count:int):void {
		var params:Array = new Array();
		params.push(count);
		card.visible = true;
		TweenLite.to(card, .5, {x: oldX, y: oldY, onComplete: dealCardsDone, onCompleteParams: params});
												  
	}

	private function dealCardsDone(count:int):void {
		//if all dealt cards finished moving
		if (count == 28) {
			for (var i:uint = 0; i < 7; i++) 
			{
				var kp:KlondikePile = klondikePiles[i] as KlondikePile;
			
				
				var card:VisualCard = kp.getTopCard();

				if (card != null) {
						configureDrag(card);
				}
			} 
		}
	}
	/**
	 * Configure the event listeners for the game
	 */
	protected function setupListeners(enable:Boolean = true):void
	{
		// Whenever the deck is clicked, we need to deal
		if (visualDeck != null) {
			if (enable) {
				visualDeck.addEventListener( MouseEvent.CLICK, deckClick );
			}
			else {
				visualDeck.removeEventListener( MouseEvent.CLICK, deckClick );			
			}
			
			// ButtonMode gives us the hand cursor
			visualDeck.buttonMode = enable;
		}
		
	}
	
	/**
	 * Event handler - the deck was clicked, determine if we
	 * can deal.
	 */
	protected function deckClick( event:MouseEvent ):VisualCard
	{
		//trace("deck click");
		// TODO: Check if can cycle based on game rules / scoring
		if ( visualDeck.isEmpty() )
		{
			//trace("resetting deck");
			this.cardDealer.reset();
			
			// Require two clicks to deal a card when the deck is empty - the
			// first click just resets the deck, and we return here so that
			// another click is required to deal
			return null;
		}
		
		//trace("deck not empty");
		
		// Remove the event listener for the previous card on the dealt pile
		// so that the user can only pick up the "top card" on the dealtPile.
		// This doens't matter in the draw-one style, so maybe we run a
		// conditional here to test that to avoid overhead of removeing listeners
		// when we don't need to.
		if ( dealtPile.numChildren > 0 )
		{
			// TODO: Really, we should do this for the last X amount of cards dealt?
			configureDrag( dealtPile.getChildAt( 0 ) as VisualCard, false );
		}
		
		var card:VisualCard = cardDealer.deal();
		
		// Deal a card onto the dealt pile, pass in false because we don't want
		// to remove the card from the deck yet (since it's not moved to a klondike
		// or ace pile just yet).
		//var card:VisualCard = new VisualCard( visualDeck.deal( false ), false );
					
		// Add the card to the dealt pile
		//dealtPile.addCard( card );
		
		//card = new VisualCard( visualDeck.deal( false ), false );
					
		// Add the card to the dealt pile
		//dealtPile.addCard( card );
		
		// Only add the event listener for the top-card.  We do things this way
		// so that if we go to deal-3 style where more than one card is visible,
		// only clicking the top card actually does something
		if (card != null) {
			configureDrag( card );
		}
		
		return card;
	}
	
	/**
	 * Configures a card for drag and drop behavior.
	 */
	public function configureDrag( card:VisualCard, canDrag:Boolean = true ):void
	{
		if (card != null) {
			// Do we add the event listeners or remove them?
			if (canDrag)
			{
				card.addEventListener( MouseEvent.MOUSE_DOWN, checkDragStart);
				card.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickCard);
				card.buttonMode = true;
			}
			else
			{
				card.removeEventListener( MouseEvent.MOUSE_DOWN, checkDragStart);
				card.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickCard);
				card.buttonMode = false;
			}
		}
	}
	protected function onDoubleClickCard(event:MouseEvent):Boolean {
		var success:Boolean = false;
		//trace("double click");
		//get the card
		var card:VisualCard;
		
		//in some cases, when cards are BitmapAssets
		if (event.target is VisualCard) {
			card = event.target as VisualCard;
		}
		//when cards are swfs
		else if (event.target is Loader) {
			// The event target is the skin, so it's parent is the visual card
			// and then the parent of that is the cardpile.
			card = event.target.parent.parent as VisualCard;
		}
//trace("card is " + card);
		if (card != null) {
			if (!(card.parent is AcePile)) {
				var origin:CardPile = card.parent as CardPile;
				//trace("dclick "+card.parent);
				
				//if the card is the top card of the parent pile
				if (origin.getTopCard() == card) {
					//loop through all ace piles
					for each (var aPile:AcePile in this.acePiles) {
						//trace("ace pile  " + aPile);
						if (aPile.canAddCard(card.card)) {
							success = true;
							//trace(card.parent);
							//if coming from the deck, remove it!
							if (card.parent == this.dealtPile) {
								//trace("coming from DEALT PILE DOUBLE CLICK");
								visualDeck.remove(card.card);
								
								checkVisualDeckEmpty();
							}
							
							aPile.addCard(card);
							
							dispatchEvent(new Event(TO_ACE_PILE));
							break;
						}
					}
					
					if (origin != null) {
						updatePileState(origin);
					}
				}
			}
		}
		
		return success;
	}
	/** 
	 * Function is really for klondike piles that are all face down or ace piles
	 * Update the state of a card pile - either turn it into a King
	 * pile, make the "new topmost card" draggable (cardPiles and dealtPile), 
	 * or in the special case that an ace was drug off an ace pile, we need to
	 * put it's empty skin back, so we can probably just call update skin
	 */
	public function updatePileState( cardPile:CardPile ):void
	{
		// Determine what kind of pile the cardPile is
		if ( cardPile is AcePile && cardPile.numChildren == 0 )
		{
			cardPile.updateSkin();
		}
		else if ( cardPile is KlondikePile )
		{
			if ( cardPile.isEmpty() )
			{
				// Empty pile, turn it into a King Pile - find a reference to
				// the Klondike pile in the list of Klondike piles and replace
				// it with a King pile.
				for ( var i:int = 0; i < klondikePiles.length; i++ )
				{
					if ( klondikePiles[i] == cardPile )
					{
						//trace("turhing into king pile");
						var kingPile:KingPile = new KingPile();
						kingPile.x = cardPile.x;
						kingPile.y = cardPile.y;
						if (contains(cardPile)) {
							removeChild( cardPile );
						}
						addChild( kingPile );
						klondikePiles[i] = kingPile;
						break;
					}
				}
			}
			else
			{
				// Make the top most card on the pile clickable (so we can turn it over)
				var vc:VisualCard = cardPile.getChildAt( cardPile.numChildren - 1 ) as VisualCard;
				
				if (vc.isDown) {
					vc.addEventListener( MouseEvent.CLICK, turnOver );
					vc.buttonMode = true;
				}
				else {
					for (var j:uint = 0; j < cardPile.numChildren; j++) {
						vc = cardPile.getChildAt(j) as VisualCard;
		
						if (vc != null && vc.isDown == false) {
							configureDrag(vc, true);
						}
					}
				}
			}
		}
		else
		{
			// cardPile is a dealt pile
			if ( cardPile.numChildren )
			{
				var top:VisualCard = cardPile.getTopCard();//cardDealer.getCardOnTop()
				
				if (top != null) {
					configureDrag(top);
				}
				
				//if its a draw one game, add an event listener to the top card
				/*if ( drawType == DRAW_ONE ) {
					configureDrag( cardPile.getChildAt( cardPile.numChildren - 1 ) as VisualCard );
				}*/
			}
		}
	}
	
	/**
	 * Turns the card that was clicked on over (so its face up).  This is
	 * used when a Klondike pile contains only face down cards - the last card
	 * in the pile can be turned over.
	 */
	public function turnOver( event:MouseEvent ):VisualCard
	{
		//trace("turn over");
		// Use currentTarget because sometimes the target is a Loader depending
		// on how the skin is implemented

		var card:VisualCard = VisualCard( event.currentTarget );
		
		// Set the card face up
		card.isDown = false;
		// Set up the card for drag and drop
		configureDrag( card );
		// It's already turned over, remove the listener
		card.removeEventListener( MouseEvent.CLICK, turnOver );
		
		return card;
	}
	
	/**
	 * Should be called after every move to update the status of the game.
	 */
	public function updateGameStatus():void
	{
		// TODO: Check for win game
		
		// TODO: Check for no more moves
		
		// TODO: Automatically make moves?
	}
	
	/**
	 * Called when the mouse is released - if there a pile currently
	 * being dragged around, check to see if we can play the pile, otherwise
	 * we need to move it back to where it came from.
	 * 
	 * @return false if card cannot be played. true if card can
	 */
	public function checkDrop( event:MouseEvent ):Boolean
	{
		trace("check drop");
	
		//get the card pile in its hierarchy if any
		var vc:VisualCard = event.target as VisualCard;//getDescendantByClass(target, VisualCard) as VisualCard;
		
		//if not a card
		if (vc == null) {
			//clean up the dragging
			cleanUpDragging();
			
			return false;
		}
		else {
			//get its parent as a pile
			var draggingPile:CardPile = vc.parent as CardPile;
			
			//if no pile
			if (draggingPile == null) {
				cleanUpDragging();
				
				return false;
			}
			else {
				
				//if the card is down then it cant
				//be a valid target
				if (vc.isDown) {
					cleanUpDragging();
							
					return false;
				}
				else {
					//if the pile cannot be played
					if (!playPile(vc.originatingCardPile, event))
					{
						cleanUpDragging();	
						
						return false;
					}
					else {
						trace("you can play it");
						return true;
					}
				}
			}
		}
	}

	private function checkVisualDeckEmpty():void {
		//if no cards in dealt and no cards in deck aka last card
		if ( visualDeck.dealtEmpty() && visualDeck.isEmpty() )
		{
			visualDeck.setCanCycleDeck(false);
			visualDeck.updateSkin();
								
			visualDeck.removeEventListener( MouseEvent.CLICK, deckClick );
			visualDeck.buttonMode = false;
		}
	}

	private static function getDescendantByClass(target:DisplayObject, c:Class):DisplayObject {
		var o:DisplayObject = target;
		while (!(o is c)) {
			//trace("get desc by class " + o);
			// Deal with drop on VisualDeck
			if ( o == null ) {
				break;
			}
			
			o = o.parent;
		}
		
		return o;
	}
	
	/**
	 * Returns true if the dragging pile could be added to the target pile,
	 * and false otherwise.
	 */
	public function playPile( originatingPile:CardPile, event:MouseEvent ):Boolean
	{
		trace(event.target + " " + event.currentTarget);
		var draggingVc:VisualCard = event.target as VisualCard;
		
		//this should be a visual card
		if (draggingVc == null) {
			return false;
		}
		
		// Get a list of everything underneath the mouse cursor
		//get the global point of the middle of the vc
		var globalVc:Point = draggingVc.localToGlobal(new Point(draggingVc.width/2,draggingVc.height/2));
		
		var dropObjs:Array = stage.getObjectsUnderPoint(globalVc);//stage.getObjectsUnderPoint( new Point( event.stageX, event.stageY ) );
	
		// If there is only one object under the point, that means the user
		// just dropped the dragging pile on the stage, so don't bother trying
		// to play the pile
		if ( dropObjs.length == 0 ) {
			return false;
		}
		
		if (originatingPile == null) {
			return false;
		}
		
		//Starting from the top, find the last object that has in its hierarchy a CardPile.
		//This is the pile that is dragged
		// Note: Deal with ace pile and empty king piles - there is no visual card in the parent chain, so we'll
		// test for is CardPile instead.
		// Note: Also deal with dropping on VisualDeck since no VisualCard or CardPile in that parent chain
		var draggingPile:CardPile;
		var target:DisplayObject;
		var index:uint;
		
		var cardPileDescendant:Boolean = false;
		for (var dropIndex:int = dropObjs.length - 1; dropIndex > -1; dropIndex--) {
			target = dropObjs[dropIndex];
			
			
			
			//if the card pile descendant has been found
			if (cardPileDescendant) {
				var temp:CardPile = getDescendantByClass(target, CardPile) as CardPile;
				
				//if this one is not in the same pile
				if (draggingPile != temp) {
					index = dropIndex;
					break;
				}	
			}
			//the card pile descendant has not been found yet
			else {
				draggingPile = getDescendantByClass(target, CardPile) as CardPile;
				
				//if not null
				if (draggingPile != null) {
					//set found to true
					cardPileDescendant = true;
				}	
			}
		}
	//	trace("target is " + draggingPile);
		
		//this is the target
		if (index > 0) {
			target = dropObjs[dropIndex];
		}
		//0 is the stage
		else {
			return false;
		}

		// Keep going through parents until we get a VisualCard, a KlondikePile, or an AcePile
		while (!( target is VisualCard || target is KlondikePile || target is AcePile ))
		{
			// Deal with drop on VisualDeck
			if ( target == null ) {
				//trace("target null");
				return false;
			}
	
			// Move up the chain
			target = target.parent;
		}
		
		var cardPile:CardPile;
		
	//	trace("target is " + target);
		
		// When we drop on a card, get the card pile the card was dropped on
		if ( target is VisualCard )
		{
			cardPile = target.parent as CardPile;
			
			// Check to make sure that the top card in the pile was actually 
			// in the drop list.  This stops the user from adding to a pile without
			// dropping on the top most card in that pile
			if ( target != cardPile.getChildAt( cardPile.numChildren - 1 ) )
			{
				//trace("target !- wha?");
				return false;
			}
		}
		else
		{
			// Dropped on an empty ace or king pile
			cardPile = target as CardPile;
		}
		
		// Check to see if we can add the dragging pile to the drop target
		if ( cardPile.canAdd( draggingPile ) && cardPile != originatingPile )
		{
			this.pileBeingDragged = null;
			draggingPile.stopDrag();
			
			// Special case - remove the card from the deck
			// if the originating pile is the dealt pile
			if ( originatingPile == dealtPile )
			{
				visualDeck.remove( VisualCard( draggingPile.getChildAt( draggingPile.numChildren - 1 ) ).card );
				
				checkVisualDeckEmpty();
				
			}

			//remove it first. if u dont remove it flash will not refresh buffer
			if (draggingPile.parent != null) {
				//almost a given but lets be careful anyways
				if (draggingPile.parent.contains(draggingPile)) {
					//trace("REMVONG CKIDDDD");
					draggingPile.parent.removeChild(draggingPile);
				}
			}
			
			for (var i:uint = 0; i < draggingPile.numChildren; i++) {
				var vc:VisualCard = draggingPile.getChildAt(i) as VisualCard;

				if (vc != null && vc.isDown == false) {
					configureDrag(vc, true);
				}
			}
			
			// Add the dragging pile to the new card pile
			cardPile.addPile( draggingPile );
			
			// Update the originating pile state
			//trace("UPDATE PILE STATE");
			updatePileState( originatingPile );
			
			if (cardPile is KlondikePile || cardPile is KingPile) {
				if (originatingPile == dealtPile) {	
					//trace("move from deck to tabelau");
					dispatchEvent(new Event(DECK_TO_KLONDIKE_PILE));
				}
				
				if (originatingPile is AcePile) {
					//trace("foudnation to tableoau");
					dispatchEvent(new Event(ACE_PILE_TO_KLONDIKE_PILE));
				}
				
				if (originatingPile is KlondikePile) {
					dispatchEvent(new Event(KLONDIKE_PILE_TO_KLONDIKE_PILE));
				}
			}

			if (cardPile is AcePile && !(originatingPile is AcePile)) {
				//trace("move  to ace");	
				dispatchEvent(new Event(TO_ACE_PILE));
			}
			
			
			// Succesfully played the pile
			return true;
		}
		
		//trace("wah?");
		// Couldn't play the pile
		return false;
	}
	
	/**
	 * Moves the dragging pile back to where it came from
	 */
	protected function moveBack(originatingPile:CardPile, draggingPile:CardPile):void
	{
		trace("move back " + draggingPile + " " + originatingPile);
		if (draggingPile != null && originatingPile != null) {
			trace("move back in");
			this.pileBeingDragged = null;
		//trace("klondike game moveBack");
		// Stop dragging
		//draggingPile.drop();
		draggingPile.stopDrag();

		//reset number of cards dragged
		//this.numDraggingChildren = 0;
		//remove all drag listeners
		for (var i:uint = 0; i < draggingPile.numChildren; i++) {
			trace("child " + i);
			var vc:VisualCard = draggingPile.getChildAt(i) as VisualCard;
			
			if (vc != null) {
				trace("vc not null");
				//turn off drag and increment
				configureDrag(vc, false);
			//	this.numDraggingChildren++;
			//	//trace("num drag is " + this.numDraggingChildren);
			}
		}
		
		//set this to null so that we can set
		//dragging pile to null. setting dragging pile
		//to null is important to avoid race conditions iwth
		//checkdrop method that occurs if player clicks pile
		//while in moiton
		//var tempPile:CardPile = draggingPile;
		//draggingPile = null;

		//add card added listener
		originatingPile.addEventListener(CardEvent.CARD_MOTION_COMPLETE, onMoveBackMotionFinished);
			
		trace("og pile " + originatingPile);
		// Merge the piles back
		originatingPile.addPileWithMotion( draggingPile );
		}
	}
	
	private function onMoveBackMotionFinished(e:CardEvent):void {
		//this.numDraggingChildren--;
		var originatingPile:CardPile = e.target as CardPile;
		
		//if all cards added
		if (originatingPile != null && originatingPile.getCardsBeingAdded() == 0) {
			//draggingPile = null;
			
			var vc:VisualCard;
			
			originatingPile.removeEventListener(CardPile.ADD_CARD, onMoveBackMotionFinished);
				
			//if the dealt pile, you only want to add to the top	
			if (originatingPile == dealtPile) {
				vc = originatingPile.getTopCard();
				configureDrag(vc, true);
			}
			else {
				//add all drag listeners
				for (var i:uint = 0; i < originatingPile.numChildren; i++) {
					vc = originatingPile.getChildAt(i) as VisualCard;

					if (vc != null && vc.isDown == false) {
						configureDrag(vc, true);
					}
				}
			}
			
			//set listener for deck
			setupListeners(true);
		}
	}
	
	/**
	 * A click + mouse move is a drag start, a click + release isn't.
	 */
	protected function checkDragStart( event:MouseEvent ):void
	{
		var vc:VisualCard = event.target as VisualCard;
		
		trace("1. check drag start");
		////trace("cehck drag start " + draggingPile);
		if (vc != null) {
			trace("check drag start " + vc);
			vc.addEventListener( MouseEvent.MOUSE_MOVE, dragStart );
			
			this.clickedCard = vc;
			//vc.addEventListener( MouseEvent.MOUSE_UP, cancelCheckDragStart );
		}	
	}

	/**
	 * Remove the drag start listener since the click wasn't a drag.
	 */
	 /*
	private function cancelCheckDragStart( event:MouseEvent ):void
	{
		
		trace("2. cancel DragStart");
		var vc:VisualCard = event.currentTarget as VisualCard;
		
		////trace("cehck drag start " + draggingPile);
		if (vc != null) {
			vc.removeEventListener(MouseEvent.MOUSE_MOVE, dragStart);
			//vc.removeEventListener( MouseEvent.MOUSE_UP, cancelCheckDragStart );
			
			checkDrop(event);
		}
	}*/
	
	/**
	 * Start dragging a card pile
	 */
	public function dragStart( event:MouseEvent ):void
	{
		trace("2. drag start");
		//remove click listener from deck
		setupListeners(false);
		
		var card:VisualCard;
		
		//in some cases, when cards are BitmapAssets
		if (event.target is VisualCard) {
			card = event.target as VisualCard;
		}
		//when cards are swfs
		else if (event.target is Loader) {
			// The event target is the skin, so it's parent is the visual card
			// and then the parent of that is the cardpile.
			card = event.target.parent.parent as VisualCard;
		}
		trace("drag start " + card);
		
		// Remove the drag start listeners
		card.removeEventListener(MouseEvent.MOUSE_DOWN, checkDragStart);
		card.removeEventListener( MouseEvent.MOUSE_MOVE, dragStart);
		
		//card.removeEventListener( MouseEvent.MOUSE_UP, cancelCheckDragStart );
		
		//store the parent as the parent card pile
		var originatingPile:CardPile = card.parent as CardPile;
		
		//originatingPile.setOriginatingCardPile(originatingPile); 
		//card.originatingCardPile = originatingPile;
		
		//trace("SET ORIGINATING PILE AS " + originatingPile);
		//if (originatingPile == null) {
		//	throw new Error("og pile nll");
		//}
		//originatingPile = card.parent as CardPile;
		
		if (originatingPile != null) {
			var draggingPile:CardPile;
			
			// Save the location of the card, so we can set the pile that it returned to that same
			// location when we re-parent to the root.  This makes the reparent seemless as there is
			// no visual change to the card's location.
			var pt:Point = new Point( originatingPile.x + card.x, originatingPile.y + card.y);
			if ( originatingPile is AcePile )
			{
				// Only remove the top card on ace piles
				draggingPile = originatingPile.removeCard( card, false );
			}
			else
			{
				// Remove the card being dragged and all of the cards below it in the pile - create
				// a new pile that spreads south
				draggingPile = originatingPile.removeCard( card, true, SpreadingDirection.SOUTH );
			}
			
			//in the originating pile, remove draglistener from top
			var ogTop:VisualCard = originatingPile.getTopCard();
			configureDrag(ogTop, false);
			
			// Reset the position of the draggingPile to the old location of the picked up card
			draggingPile.x = pt.x;
			draggingPile.y = pt.y;
			draggingPile.setOriginatingCardPile(originatingPile);
			
			// Add the dragging pile on top of everything in the main display list
			addChild( draggingPile );
			
			// TODO: figure out the correct drag bounds, use localToGlobal probably
			//draggingPile.drag( /*true, new Rectangle(-1000, -1000, 1000, 1000)*/ );
			//draggingPile.startDrag();
			
			//stop dragging for og pile
			for (var i:uint = 0; i < originatingPile.numChildren; i++) {
				card = originatingPile.getChildAt(i) as VisualCard;
				
				if (card != null && !card.isDown) {
					configureDrag(card, false);
				}
			}
			
			// Add the filters to the dragging pile
			draggingPile.filters = SkinManager.skinCreator.dragFilters;
	
			draggingPile.startDrag();
			
			this.pileBeingDragged = draggingPile;		
			
		}
	}
	private var clickedCard:VisualCard;
	private var pileBeingDragged:CardPile;
	

	
	
} // end class
} // end package