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
package as3cards.visual
{
	import as3cards.core.Card;
	
	import com.zerog.utils.geom.Position;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gs.TweenLite;

/**
 * A CardPile is a container that stores visual cards.  The spreading
 * direction determines how new cards display when they are added
 */
public class CardPile extends DraggableSprite implements Skinnable
{
	
	// Don't need an array to store the cards, we can just rely on the internal display list
	//public var visualCards:Array;
	
	/** One of the <code>SpreadingDirection</code> constants */
	private var spreadingDirection:int;
	
	private var cardInMotion:VisualCard;
	private var cardsBeingAdded:uint;
	
	private var lostCardQueue:Array = new Array();
	
	public static const DOWN_DISTANCE:uint = 5;
	public static const UP_DISTANCE:uint = 20;
	
	public var upDistance:uint = UP_DISTANCE;
	public var downDistance:uint = DOWN_DISTANCE;
	
	public static const ADD_CARD:String = "add card to card pile";
	/**
	 * Constructor
	 * 
	 * @param spreadingDirection defaults to SpreadingDirection.NONE
	 */
	public function CardPile( card:VisualCard = null, spreadingDirection:int = 0 )
	{
		// Save the spreading direction to know how to add cards
		this.spreadingDirection = spreadingDirection;
		
		// Create the pile with an initial card
		if ( card != null )
		{
			addCard( card );
		}
	}
	override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
		for (var i:uint = 0; i < numChildren; i++) {
			var vc:VisualCard = getChildAt(i) as VisualCard;
			if (vc != null) {
				vc.setIsDragging(true);
				
				//trace("START DRAG ON "  + vc);
			}
		}
		
		super.startDrag(lockCenter, bounds);
	}
	override public function stopDrag():void {
		//trace("CPO STOP DRAG");
		for (var i:uint = 0; i < numChildren; i++) {
			var vc:VisualCard = getChildAt(i) as VisualCard;
			if (vc != null) {
				vc.setIsDragging(false);
				
				//trace("STOP DRAG ON "  + vc);
			}
		}
		super.stopDrag();
	}
	
	public function hasFaceDownCards():Boolean {
		var hasFaceDown:Boolean = false;
		
		for (var i:uint = 0; i < numChildren; i++) {
			var vc:VisualCard = getChildAt(i) as VisualCard;
			
			if (vc != null && vc.isDown) {
				hasFaceDown = true;
				break;
			}
		}
		
		return hasFaceDown;
	}
	
	public function setOriginatingCardPile(cp:CardPile):void {
		for (var i:uint = 0; i < numChildren; i++) {
			var vc:VisualCard = getChildAt(i) as VisualCard;
			if (vc != null) {
				vc.originatingCardPile = cp;
			}
		}
	}
	
	public function getCardsBeingAdded():uint {
		return this.cardsBeingAdded;
	}
	
	public function setSpreadingDirection(direction:int):void {
		this.spreadingDirection = direction;
	}
	public function getSpreadingDirection():int {
		return this.spreadingDirection;
	}
	
	/**
	 * Determines if a card can be added to the card pile.  In
	 * the default base class here, there is no limitations to
	 * how cards are added, so always return true.
	 */
	public function canAdd( cardPile:CardPile ):Boolean
	{
		return true;
	}
	
	/**
	 * Determines if a card can be added to the card pile.  In
	 * the default base class here, there is no limitations to
	 * how cards are added, so always return true.
	 */
	public function canAddCard(card:Card):Boolean {
		return true;
	}
	
	/**
	 * Adds the contens of another card pile to this one
	 */
	public function addPile( cardPile:CardPile ):void
	{
		// Save the numChildren as it'll get modified during the loop
		var total:int = cardPile.numChildren;
		
		// Reparent the visual cards from the card pile to this one
		for ( var i:int = 0; i < total; i++ )
		{
			addCard( cardPile.getChildAt( 0 ) as VisualCard );
		}
	}
	
	public function addCardWithMotion(vc:VisualCard, i:uint=0, delay:Number=0, time:Number = 0.3):void {
		if (vc != null) {
			//get the global coordinates
			var p:Point = Position.getGlobal(vc);
				
			if (this.stage != null) {
				//add it to the stage
				this.stage.addChild(vc);
			}
			
			//move it
			vc.x = p.x;
			vc.y = p.y;
				
			//get the proper location
			p = getNextCardLocation(i, vc.isDown);
				
			//get the global position
			p = localToGlobal(p);
				
			//move it
			TweenLite.delayedCall(delay, moveCard, new Array(vc, p, time));	
		}
	}
	
	/*
	 * Assumes all cards to add are face up or down
	 */
	public function addPileWithMotion(cardPile:CardPile):void {
		
		// Save the numChildren as it'll get modified during the loop
		var total:int = cardPile.numChildren;
		this.cardsBeingAdded = total;
		var p:Point;
		var vc:VisualCard;
		
		//loop again
		for ( var i:uint = 0; i < total; i++ )
		{
			vc = cardPile.getChildAt( 0 ) as VisualCard;
			addCardWithMotion(vc,i,.05 * i);
		}
	}
	
	private function moveCard(vc:VisualCard, p:Point, time:Number):void {
		this.cardInMotion = vc;
		addEventListener(Event.ENTER_FRAME, onEnterFrameAnimation);
		TweenLite.to(vc, time, {x: p.x, y: p.y, onComplete: animateAddCard, onCompleteParams: new Array(vc)});
	}

	private function onEnterFrameAnimation(e:Event):void {
		dispatchEvent(new CardEvent(CardEvent.CARD_IN_MOTION, this.cardInMotion));
	}

	private function animateAddCard(vc:VisualCard):void {
		this.cardInMotion = null;
		
		removeEventListener(Event.ENTER_FRAME, onEnterFrameAnimation);
		
		var top:VisualCard = getTopCard();
		//if this is the right card to add
		if (top == null || top.isDown || canAddCard(vc.card)) {
			this.cardsBeingAdded--;
			
			//add it
			addCard(vc);
			
			dispatchEvent(new CardEvent(CardEvent.CARD_MOTION_COMPLETE, vc));
		}
		//this card is wrong
		else {
			//add it to the queue
			this.lostCardQueue.push(vc);
			
			trace("add to lost card queue " + vc + " because top card is " + top);
		}
		
		//if all the cards have either been added or are in the lost car queue
		if (this.cardsBeingAdded == this.lostCardQueue.length) {
			//while still cards in lost card queue
			while(this.lostCardQueue.length > 0) {
				//if the last can be added
				var lc:VisualCard = this.lostCardQueue.pop() as VisualCard;
				if (canAddCard(lc.card)) {
					
					//add it
					addCard(lc);
					
					//decrement remaining # to be added
					this.cardsBeingAdded--;
					
					//displathc event
					dispatchEvent(new CardEvent(CardEvent.CARD_MOTION_COMPLETE, lc));
				}
				//else add it to the beginning
				else {
					this.lostCardQueue.unshift(lc);
				}
			}
		}
	}
	public function isEmpty():Boolean {
		//if no children or
		//if one child and that is not a visual card
		if (numChildren == 0 || (numChildren == 1 && !(getChildAt(0) is VisualCard))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	private function prepPile():void {
		// If there is a skin here and we add a card, we need to remove
		// the skin before the card is added
		if ( numChildren == 1 && !( getChildAt( 0 ) is VisualCard ) )
		{
			removeChildAt( 0 );
		}
	}
	
	/**
	 * Adds a visual card to this card pile 
	 */
	public function addCard( card:VisualCard ):void
	{
		//prep the pile
		prepPile();
		
		//if has a parent, have the parent remove the kid
		if (card.parent != null) {
			card.parent.removeChild(card);
		}
		
		//get the location
		var p:Point = getNextCardLocation();
		card.x = p.x;
		card.y = p.y;
		
		//add it
		addChild(card);
		
		dispatchEvent(new Event(ADD_CARD));
	}
	
	/*
	 * Get the next card location
	 * @param cardNum - The nth card to add to the pile
	 * @param prevFaceDown - Whether the previous card in the pile is face up or down.
	 * If prevFaceDown is true, assumes all cards before cardNum that need to be added 
	 * are face down and vice versa for face up 
	 */
	public function getNextCardLocation(cardNum:uint = 0, prevFaceDown:Boolean = true):Point {
		var p:Point = new Point();
		p.x = 0;
		p.y = 0;
		////trace("get next  num child " + numChildren);
		// if more than skin
		//if ( numChildren > 1 )
		//{
		// Get previous card
		var vc:VisualCard = getTopCard();
			
		var isDown:Boolean;
		var x:Number;
		var y:Number;
		var distance:Number;
		
		if (vc == null) {
			x = 0;
			y = 0; 
			distance = 0;
		}
		else {
			x = vc.x;
			y = vc.y;
			isDown = vc.isDown;
			
			//spread down cards less
			if (isDown) {
				distance = this.downDistance;
			}
			else {
				distance = this.upDistance;
			}
		}
		
		// Set the location of the card 
		p.x = x;
		p.y = y
			
		//only if this is predicting where the future card will be
		if (cardNum > 0) {
			//if the previous card is face down
			if (prevFaceDown) {
				distance += (cardNum * this.downDistance);
			}
			else {
				distance += (cardNum * this.upDistance);
			}
		}
		
		// Adjust the card position based on the pile's spread direction
		switch ( spreadingDirection )
		{
			case SpreadingDirection.NORTH: 
				// TODO: get "north adjustment" amount from the skin manager
				p.y -= distance;
				break;
				
			case SpreadingDirection.SOUTH:
				// TODO: get "south adjustment" amount from the skin manager
				p.y += distance;
				break;
				
			case SpreadingDirection.EAST:
				// TODO: get "east adjustment" amount from the skin manager
				p.x += distance;
				break;
				
			case SpreadingDirection.WEST:
				// TODO: get "west adjustment" amount from the skin manager
				p.x -= (distance * cardNum);
				break;
			
			case SpreadingDirection.NONE: 
				// No need to change x or y, it'll just stack directly on top
				// with no offset
				break;
		}
		
		return p;
	}
	
	/**
	 * Removes a card from the pile and returns a new CardPile containing the card.  If
	 * removeAllAfter is specified, all of the cards that were added after the card that
	 * is being removed are removed along with the card (and placed in the card pile
	 * that is returned).
	 */
	public function removeCard( card:VisualCard, removeAllAfter:Boolean = true, spreadingDirection:int = 0 ):CardPile
	{
		// Get the current display list index of the card to remove
		var index:int = getChildIndex( card );
		// Add the card to the card pile that we want to return
		var cardPile:CardPile = new CardPile( card, spreadingDirection );
					
		// Add all of the cards that come after the card to the new card pile.
		if ( removeAllAfter )
		{
			// Save numChildren since it will be modified during each
			// loop iteration
			var total:int = numChildren;
			for ( var i:int = index; i < total; i++ )
			{
				// Adding a card will re-parent it to the cardPile,
				// so we don't have to worry about calling removeChildAt here.
				cardPile.addCard( VisualCard( getChildAt( index ) ) );
			}
		}
		
		updateSkin();
		
		return cardPile;
	}
	
	public function copy():CardPile {
		//make a new kpile
		var cPile:CardPile = new CardPile();
		cPile.x = this.x;
		cPile.y = this.y;
							
		var vc:VisualCard = null;
		
		//for each card in the current kpile
		for (var i:uint = 0; i < this.numChildren; i++) {
			vc = getChildAt(i) as VisualCard;
						
			if (vc != null) {
				//push it into the new kpile
				cPile.addCard(new VisualCard(vc.card.copy(), vc.isDown));
			}
		}
					
		return cPile;
	}
	
	public function getTopCard():VisualCard {
		if (isEmpty()) {
			return null;
		}
		else {
			var vc:VisualCard = getChildAt(numChildren - 1) as VisualCard;
			
			return vc;
		}
	}
	
	/**
	 * Creates the visual images for the card pile
	 */
	public function updateSkin():void
	{
		for (var i:int = 0; i < numChildren; i++) {
			var vc:VisualCard = getChildAt(i) as VisualCard;
			
			if (vc != null) {
				vc.updateSkin();
			}
		}
		// TODO: loop over all of the cards in the pile and update their skins
	}
	
	override public function toString():String {
		var s:String = "BEGIN PILE OUTPUT\n"; 
		
		for (var i:int = 0; i < numChildren; i++) {
			var vc:VisualCard = getChildAt(i) as VisualCard;
			if (vc != null) {
				s += "\t" + vc.toString() + "\n";
			}
		}
		s += "END PILE OUTPUT";
		
		return s;
	}
} // end class
} // end package