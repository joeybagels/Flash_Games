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
	
import as3cards.core.Card;
import as3cards.core.CardValue;
import as3cards.visual.CardPile;
import as3cards.visual.SkinManager;
import as3cards.visual.VisualCard;

import flash.events.Event;

/**
 * An AcePile is a CardPile that only accepts the "next card"
 * in ascending order, of the same suit as the Ace.
 */
public class AcePile extends CardPile
{
	
	private var lastAdded:Date = null;
	
	/**
	 * Constructor
	 */
	public function AcePile()
	{
		super( null );
		updateSkin();
	}
	
	/**
	 * Deep copy
	 */
	override public function copy():CardPile {
		//make a new kpile
		var aPile:AcePile = new AcePile();
		aPile.x = this.x;
		aPile.y = this.y;
							
		var vc:VisualCard = null;
		
		//for each card in the current kpile
		for (var i:uint = 0; i < this.numChildren; i++) {
			vc = getChildAt(i) as VisualCard;
						
			if (vc != null) {
				//push it into the new kpile
				aPile.addCard(new VisualCard(vc.card.copy(), vc.isDown));
			}
		}
					
		return aPile;
	}
	
	override public function canAddCard(cardToAdd:Card):Boolean {
	
		// The first card must be an ace - check to see if the only thing
		// displaying is the skin at the moment.
		if ( numChildren == 0 && cardToAdd.value == CardValue.ACE) {
			return true;
		}
		else if ( numChildren == 1 && !( getChildAt( 0 ) is VisualCard ) )
		{
			if ( cardToAdd.value == CardValue.ACE )
			{
				return true;
			}
		}
		else
		{
			// Get the top card from the pile and the card attempting to be added
			var top:VisualCard = getChildAt( numChildren - 1 ) as VisualCard;
			
			// Check same suit
			if ( top.card.suit == cardToAdd.suit )
			{
				// Check that the next card value is directly after the current
				// top card
				if ( top.card.value == cardToAdd.value - 1 )
				{
					return true;
				}
				// Special case, check for ace and 2
				if ( top.card.value == CardValue.ACE && cardToAdd.value == CardValue.TWO )
				{
					return true;
				}
			}
		}
		
		// Reject the card pile because it doesn't meet the criteria
		return false;
	}
	
	/**
	 * Override can add so we can create custom logic to accept / reject
	 * the card pile.
	 */
	public override function canAdd( cardPile:CardPile ):Boolean
	{
		// Can only drag one card at a time to the ace pile
		if ( cardPile.numChildren > 1 )
		{
			return false;
		}
		
		var topCard:VisualCard = cardPile.getChildAt( 0 ) as VisualCard;
		
		return canAddCard(topCard.card);
	}
	
	/**
	 * Creates the visual images for the card pile
	 */
	public override function updateSkin():void
	{
		// Check to see if a skin has been created yet
		if ( numChildren == 0 )
		{
			addChild( SkinManager.skinCreator.createEmptyAce() );
		}
		else if ( numChildren == 1 && !( getChildAt( 0 ) is VisualCard ) )
		{
			// If there is only 1 child and it's not a visual card, then 
			// it must be just the skin, so we'll replace it as necessary
			removeChildAt( 0 );
			addChild( SkinManager.skinCreator.createEmptyAce() );
		}
		
		// Update the skin of all of the cards in the pile
		super.updateSkin();
	}
	
	public override function addCard(card:VisualCard):void {
		this.lastAdded = new Date();
		
		super.addCard(card);
	}
	
	public override function addPile(cardPile:CardPile):void {
		this.lastAdded = new Date();
		super.addPile(cardPile);
	}
	
	public function getLastAdded():Date {
		return this.lastAdded;
	}
} // end class
} // end package