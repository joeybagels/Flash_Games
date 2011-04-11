package com.zerog.components.scroller {
	import flash.display.DisplayObject;		

	/**
	 * @author Chris
	 */
	public interface IScroller {
		function setRewindButtonPosition(xPos:Number, yPos:Number):void;
		
		function setForwardButtonPosition(xPos:Number, yPos:Number):void;
		
		/*
		 * Sets the position of the thumb and calls <code>adjustTargetPosition</code>
		 * when done
		 * @see #adjustTargetPosition(pos:Number)
		 */
		function setThumbPosition(pos:Number):void;
		
		function setGutterPosition(xPos:Number, yPos:Number):void;
		
		function setGutterSize(length:Number):void;
		
		/*
		 * Refers to the number of pixels to move at a time if the target is not a text field
		 * If the target is a text field, this equals the number of lines to jump
		 */
		function setScrollJump(jumpSize:int):void;
		
		function setSpeed(millis:uint):void;
		
		function setThumbOutside(outside:DisplayObject):void;
		
		/*
		 * Sets the target object to be scrolled
		 * @param scrollTarget - This <code>DisplayObject</code> can either be a <code>TextField</code> or other subclass
		 * @param boundaryStart - The coordinate of the viewable window for the scroll.  The value should be the left <code>x</code>
		 * coordinate if the scrolling is set to be horizontal or the top <code>y</code> coordinate if the scrolling is set to be vertical.
		 * @param boundaryEnd - Same as the boundaryStart except that the value should be the bottom <code>y</code> or right <code>x</code>
		 * @param thumbOutside - The object that will fire <code>MouseEvent.MOUSE_UP</code> events that will tell the thumb button to stop
		 * scrolling.  This is needed in case the user performs a "release outside".
		 */
		function setTarget(scrollTarget:DisplayObject, 
			boundaryStart:Number = 0, boundaryEnd:Number = 0, thumbOutside:DisplayObject = null):void ;
		
		/*
		 * Adjust the thumb size based on the sizes of the target and scroll boundary
		 */
		function adjustThumbSize(targetSize:int, boundarySize:Number, minThumbSize:Number = 0):void;
		
		/*
		 * Find the distance the thumb can move
		 */
		function getThumbScrollLength():Number;

		/*
		 * Set the flag to dictate whether this is vertically or horizontally scrolling
		 */
		function setScrollVertical(verticalDirection:Boolean):void;
		
		/*
		 * By default set the gutter to extend from the forward and rewind buttons
		 * Assumes that in a vertical scroll, rewind is on top of forward and in
		 * horizontal scroll, rewind is to the left of forward
		 */
		function setDefaultGutter():void;

		/*
		 * Set the distance that the thumb button can move. By default it can move in between the
		 * forward and rewind buttons
		 */
		function setDefaultThumbLimits():void;
		
		/*
		 * Enable scrolling and adjust any visible aspect to represent an enabled scroll
		 */
		function enableScroll():void;
		
		/*
		 * Tries to move the thumb button to desired position
		 * @param - The desired position
		 * @return - The actual new position of the thumb
		 */
		function moveThumb(newThumbPos:Number):Number;

		function moveThumbEnd():void;
		
		function moveThumbStart():void;
		
		/*
		 * Disables the scroll and adjusts any visible aspect of a disabled scroll
		 */
		function disableScroll():void;

		/*
		 * Adjust the display to represent a disabled scroll
		 */
		function setDisabledDisplay():void;
		
		/*
		 * Adjust the display to represent an enabled scroll
		 */
		function setEnabledDisplay():void;
		
		/*
		 * Enable or disable the scroll as needed
		 */
		function checkScroll():Boolean;
		
		/*
		 * Updates the scroll bar if the target or boundary size has changed.
		 * Will enable or disable scrolling as well as adjusting the thumb size
		 */
		function update():void;
	}
}
