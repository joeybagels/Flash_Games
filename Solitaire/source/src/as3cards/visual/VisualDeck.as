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
import as3cards.core.Deck;

import flash.display.Sprite;

/**
 * A VisualDeck is a wrapper for the Deck class, encapsulating
 * the Deck functionality inside of a skinnable Sprite.
 */
public class VisualDeck extends Sprite implements Skinnable
{
	
	// Compoisiton - VisualDeck "has a" Deck
	public var deck:Deck;
	
	/**
	 * True if the deck can be cycled through (affects which skin is
	 * displayed when the deck is empty)
	 */
	private var canCycle:Boolean;
	
	
	/**
	 * Constructor
	 * 
	 * @param deckType One of the DeckType constants
	 * @param canCycle Flag to determine what skin is displayed when
	 * 				the deck is empty.  When false, the default empty
	 * 				skin is the red x.  When true, the default empty
	 * 				skin is the green circle.
	 */
	public function VisualDeck(deckType:int, canCycle:Boolean = true )
	{
		
		deck = new Deck( deckType );
			
		this.canCycle = canCycle;
		// Draw the initial state of the deck, this will create the
		// "back of deck" image.
		updateSkin();
	}
	
	/**
	 * Deep copy
	 */
	public function copy():VisualDeck {
		var vd:VisualDeck = new VisualDeck(this.deck.getType(), this.canCycle);
		vd.x = this.x;
		vd.y = this.y;
			
		var card:Card = null;
		var array:Array = new Array();
		var deck:Deck = new Deck(this.deck.getType());
		
		//for each card in the deck
		for each (card in this.deck.cards) {
			if (card != null) {
				//make a copy of it
				array.push(card.copy());
			}
		}
			
		//set the cards
		deck.cards = array;

		//for each dealt card			
		array = new Array(); 
		for each (card in this.deck.dealtCards) {
			if (card != null) {
				array.push(card.copy());
			}
		}
		
		//set the dealt cards	
		deck.dealtCards = array;
		
		//set the deck	
		vd.deck = deck;
			
		vd.updateSkin();
		
		return vd;
	}
	
	public function getDeckType():int {
		return this.deck.getType();
	}
	
	public function setCanCycleDeck(canCycle:Boolean):void {
		this.canCycle = canCycle;
	}
	
	public function canCycleDeck():Boolean {
		return this.canCycle;
	}
	
	/**
	 * Shuffles the deck
	 */
	public function shuffle():void
	{
		// Proxy the method to the deck
		deck.shuffle();
	}
	
	/**
	 * Deals a card from the deck, and by default removes it
	 * enritely from the deck (assuming that the card is being
	 * dealt into a player's hand).
	 * 
	 * @param removeCard When true the card dealt should is removed
	 * 				from the deck. When false, the card dealt is added
	 * 				to the dealt cards list.  Call reset() to add the
	 *  			dealt cards back into the deck
	 * @return A reference to the Card dealt
	 */
	public function deal( removeCard:Boolean = true ):Card
	{
		// Proxy the method to the deck
		var card:Card = deck.deal( removeCard );
		
		// It's possible the deck is now empty, so update the skin
		updateSkin();
		
		// Finally, return the card that was dealt
		return card;
	}
	
	/**
	 * Completely removes a card from the deck, such as when
	 * a card is moved from the deck to a player's hand.
	 * 
	 * @param card A reference to the card that should be removed
	 * 			from the deck.
	 */
	public function remove( card:Card ):void
	{
		// Proxy the method to the deck
		deck.remove( card );
		
		// It's possible the deck is now empty, so update the skin
		updateSkin();
	}
	
	/**
	 * Adds all of the dealt cards back into the deck
	 * so you can deal them again.
	 */
	public function reset():void
	{
		// Proxy the method to the deck
		deck.reset();
		
		// It's possible the deck went from empty to not empty, 
		// so update the skin
		updateSkin();
	}
	
	/**
	 * Inspect the top card on the deck
	 * 
	 * @return A reference to the top card in the deck
	 */
	public function top():Card
	{
		// Proxy the method to the deck
		return deck.top();
	}
	
	/**
	 * Determine if the deck of cards is empty is not
	 */
	public function isEmpty():Boolean
	{
		// Proxy the method to the deck
		return deck.isEmpty();
	}
	
	/**
	 * Determine if the dealt cards in memory is empty or not
	 */
	public function dealtEmpty():Boolean {
		return deck.dealtEmpty();
	}
	
	/**
	 * Determines which graphic to display for the deck - either
	 * the image of the back of the deck, a "ok to cycle" image such
	 * as a green circle, or a "no more cylcing allowed" image such
	 * as a red x.
	 */
	public function updateSkin():void
	{
		// if we have a skin already, we need to remove it
		// so we can add a new one
		if ( numChildren == 1 )
		{
			removeChildAt( 0 );
		}
		
		// determine state of the deck and add the appropriate skin
		if ( deck.isEmpty() )
		{
			addChild( SkinManager.skinCreator.createCycleDeck( canCycle ) );
		}
		else
		{
			addChild( SkinManager.skinCreator.createDeck());	
		}
	}		

} // end class
} // end package