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
package as3cards.core
{

/**
 * A Deck is a collection of Cards, both dealt and undealt.
 */
public class Deck
{
	/** The type of deck.  One of the <code>DeckType</code> constants. */
	protected var type:int;
	
	/** Storage for the cards that have not been dealt yet. */
	public var cards:Array;
	
	/** Storage for the cards that already have been dealt. */
	public var dealtCards:Array;

	/**
	 * Constructs a new deck, configured via a DeckType constant.
	 */
	public function Deck( type:int )
	{
		this.type = type;
		init();
	}

	public function getType():int {
		return this.type;
	}
	/**
	 * Adds all of the cards back to the deck that may have
	 * been removed, and puts the deck in a logical order
	 */
	public function init():void
	{
		// Initialize the card arrays so we can store data in the,m
		cards = new Array();
		dealtCards = new Array();

		// Sadly, this code is messy because enumerated types aren't supported.  I really want to loop
		// over all of the card values, but since it's not a "real" enumerated type, I can't.  Instead
		// we'll create an array of the values to loop over
		var values:Array = [ CardValue.JOKER, CardValue.TWO, CardValue.THREE, CardValue.FOUR,
							 CardValue.FIVE, CardValue.SIX, CardValue.SEVEN, CardValue.EIGHT, 
							 CardValue.NINE, CardValue.TEN, CardValue.JACK, CardValue.QUEEN,
							 CardValue.KING, CardValue.ACE ];
		
		var suits:Array = [ Suit.HEARTS, Suit.DIAMONDS, Suit.CLUBS, Suit.SPADES ];
		
		// Include jokers in the deck or not?
		var i:int = type == DeckType.WITH_JOKERS 
					? 0  // First card should be a joker, start at index 0
					: 1; // Skip past the first joker and start at index 1, which is CardValue.TWO
		
		// Loop over all of the possible card values
		while ( i < values.length )
		{
			// For each card value, loop over all 4 suits and add a card to the deck
			for ( var j:int = 0; j < suits.length; j++ )
			{
				// Create a new card...
				var card:Card = new Card( values[i], suits[j] );
				// ...and add it to our deck
				cards.push( card );
			}
			i++; // Next card value
		}
	}
	
	/**
	 * Moves all of the cards from the dealt pile back onto
	 * the list of avaialable cards in the deck.
	 */
	public function reset():void
	{
		var l:int = dealtCards.length;
		while ( l-- )
		{
			cards.unshift( dealtCards.shift() );
		}
	}

	/**
	 * Shuffles all of the remaining cards in the deck that
	 * haven't been dealt yet
	 */
	public function shuffle():void
	{
		var tempCards:Array = new Array();
		
		// Save the length of the cards since it will vary for each
		// loop iteration
		var l:int = cards.length;
		for (var i:int = 0; i < l; i++)
		{
			// Pick out a random card from the undealt cards
			var randomIndex:int = Math.floor( Math.random() * cards.length );
							
			// Remove the card at the index from the card pile
			// and add the card to the tempCards array
			tempCards.push( cards.splice( randomIndex, 1 )[0] );
		}
		
		// At this point, cards is empty and tempCards contains the cards
		// in random order, so copy the tempCard values into cards
		for (i = 0; i < l; i++)
		{
			cards.push( tempCards[i] );
		}
		
	}

	/**
	 * Used to inspect the top card of the deck.  If the deck
	 * is empty an error is thrown
	 */
	public function top():Card
	{
		
		if ( isEmpty() )
		{
			throw new DeckEmptyError();
		}

		return cards[0];
	}

	/**
	 * Places the top card on the deck to the top of the
	 * dealt card list, and returns the card.  If removeCard
	 * is specified the card is removed completely instead
	 * of added to the dealt list.
	 */
	public function deal( removeCard:Boolean ):Card
	{
		var card:Card = top();
		cards.shift();
		dealtCards.unshift( card );
		if ( removeCard )
		{
			remove( card );
		}
		return card;
	}

	/**
	 * Adds card to the front of the deck 
	 */
	public function prepend(card:Card):void {
		this.cards.unshift(card);
	}

	/**
	 * Adds card to the back to deck 
	 */
	public function add(card:Card):void {
		this.cards.push(card);
	}
	
	public function addAt(card:Card, index:uint):void {
		this.cards.splice(index,0,card);
	}
	
	/**
	 * Removes a card from the deck permanently (until reset
	 * is called).

	 * @param card the card to be removed
	 * @return true if the card was removed (found in deck), false otherwise
	 */
	public function remove( card:Card ):Boolean
	{
		var i:int;
		var len:int;
		
		// Search for the card in the dealt pile
		len = dealtCards.length;
		for ( i = 0; i < len; i++ )
		{
			if ( (dealtCards[i] as Card).equals( card ) )
			{
				dealtCards.splice( i, 1 );
				return true;
			}
		}
		
		// Search for the card in the not dealt pile
		len = cards.length;
		for ( i = 0; i < len; i++ )
		{
			if ( (cards[i] as Card).equals( card ) )
			{
				cards.splice( i, 1 );
				return true;
			}
		}
		
		// Couldn't find the card to remove
		return false;
	}
	
	/**
	 * Determine if the deck is capable of dealing
	 * out any more cards.  When false, call reset to
	 * add the dealt cards back into the deck.  If after
	 * resetting the deck isEmpty() is still false, that
	 * means all of the cards from the deck have been
	 * removed.  Call init() to re-create the deck.
	 */
	public function isEmpty():Boolean
	{	
		return ( cards.length == 0 );
	}
	
	public function dealtEmpty():Boolean {
		return (dealtCards.length == 0);
	}

} // end class
} // end package