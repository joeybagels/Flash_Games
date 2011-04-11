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

import as3cards.core.CardValue;
import as3cards.visual.CardPile;
import as3cards.visual.SkinManager;
import as3cards.visual.VisualCard;

/**
 * A KingPile is a special KlondikePile that only allows the
 * first card added to the pile to be a King.  When the pile
 * is empty, it also has a special skin.
 */
public class KingPile extends KlondikePile
{
	
	/**
	 * Constructor
	 */
	public function KingPile()
	{
		super();
		// Draw the initial state
		updateSkin();
	}
	
	/**
	 * Only allow the add if the first card is a King
	 */
	public override function canAdd( cardPile:CardPile ):Boolean
	{
		// The first card must be a king - check to see if the only
		// thing in the pile is currently the skin
		if ( numChildren == 1 && !( getChildAt( 0 ) is VisualCard ))
		{
			var possibleKing:VisualCard = cardPile.getChildAt( 0 ) as VisualCard;
			// If the card is a King, it's safe to add
			return possibleKing.card.value == CardValue.KING;
		}
		else
		{
			// The pile already has a King added, so default to the regular
			// KlondikePile behavior
			return super.canAdd( cardPile );
		}
	}
	
	/**
	 * Determines what skin should be displayed
	 */
	public override function updateSkin():void
	{
		if ( numChildren == 0 )
		{
			addChild( SkinManager.skinCreator.createEmptyKing() );
		}
		else if ( numChildren == 1 && !( getChildAt( 0 ) is VisualCard ) )
		{
			// If there is only 1 child and it's not a visual card, then 
			// it must be just the skin, so we'll replace it as necessary
			removeChildAt( 0 );
			addChild( SkinManager.skinCreator.createEmptyKing() );
		}
	}

} // end class
} // end package