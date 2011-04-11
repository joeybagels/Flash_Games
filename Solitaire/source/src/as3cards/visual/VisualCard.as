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

import flash.display.Sprite;

/**
 * A VisualCard is a wrapper for the Card class, encapsulating
 * the card functionality inside of a skinnable Sprite.
 */
public class VisualCard extends Sprite implements Skinnable
{

	private var _parentCardPile:CardPile;
	private var _card:Card;
	private var _isDown:Boolean;
	private var dragging:Boolean;
	/**
	 * Constructor
	 */
	public function VisualCard( card:Card, isDown:Boolean = false )
	{
		this._card = card;
		this.isDown = isDown;
		this.doubleClickEnabled = true;
		this.dragging = false;
		// Draw the initial skin
		updateSkin();
	}
	public function setIsDragging(drag:Boolean):void {
		this.dragging = drag;
	}
	public function isDragging():Boolean {
		return this.dragging;
	}
	public function get originatingCardPile():CardPile {
		return this._parentCardPile;
	}
	
	public function set originatingCardPile(cp:CardPile):void {
		trace("SET OG PILE in " + this + " " + cp);
		this._parentCardPile = cp;
	}
	
	/**
	 * Is the card showing the back or the front?  When true,
	 * the back of the card is displayed.
	 */
	public function get isDown():Boolean
	{
		return this._isDown;
	}
	
	public function set isDown( value:Boolean ):void
	{
		// Only set the value if it's different from what the
		// value currently is
		if ( this._isDown != value )
		{
			this._isDown = value;
			
			// The card could have been flipped over, so update the skin
			updateSkin();
		}
	}
	
	/**
	 * A reference to the actual card
	 */
	public function get card():Card
	{
		return this._card;
	}
	
	/**
	 * Creates the graphic for the card
	 */
	public function updateSkin():void
	{
		// Has the skin been drawn initially?
		if ( numChildren == 1 )
		{
			// If so, remove the skin since we're recreating
			removeChildAt(0);
		}
		
		if ( this._isDown )
		{
			trace("create new deck image");
			// Use the deck skin
			addChild( SkinManager.skinCreator.createDeck() );
		}
		else
		{
			// Use the skin for the card's value
			addChild( SkinManager.skinCreator.createCard( card ) );
		}
	}

	public override function toString():String
	{
		return "[VisualCard(card:" + _card + ", isDown:" + _isDown + ", isDragging:" + dragging + ")]";	
	}

}
}