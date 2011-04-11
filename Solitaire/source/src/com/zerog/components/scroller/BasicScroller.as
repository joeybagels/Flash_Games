package com.zerog.components.scroller {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import com.zerog.components.scroller.IScroller;	

	/**
	 * @author Chris
	 * 
	 * Does not fully support horizontal scrolling yet
	 */
	public class BasicScroller extends Sprite implements IScroller {
		public var rewindButton:Sprite;
		public var forwardButton:Sprite;
		public var thumbButton:Sprite;
		public var gutter:Sprite;

		protected var isVertical:Boolean;
		protected var scrollStart:Number;
		protected var scrollEnd:Number;
		protected var scrollTargetText:TextField;
		protected var scrollTargetContainer:DisplayObjectContainer;
		protected var scrollButtonTimer:Timer;
		protected static const REWIND:int = 0;
		protected static const FORWARD:int = 1;
		protected var direction:int;
		protected var jumpSize:int;
		protected var interval:uint;
		protected var thumbEnd:Number;
		protected var thumbStart:Number;
		protected var isTextField:Boolean;
		protected var outside:DisplayObject;
		protected var thumbDragTimer:Timer;
		protected var minThumbSize:Number;
		protected var boundaryDimension:Number;
		protected var gutterTimer:Timer;
		protected var gutterMouseEvent:MouseEvent;

		public function BasicScroller(rewindButton:Sprite = null, forwardButton:Sprite = null,
			thumbButton:Sprite = null, gutter:Sprite = null, isVertical:Boolean = true, minThumbSize:Number = 10) {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ADDED, onAddedToStage);
			
			//set the minimum size for the thumb
			this.minThumbSize = minThumbSize;
			
			//set the vertical scroll flag
			this.isVertical = isVertical;
			
			//set the interval for the timers
			this.interval = 75;
			
			//set the scroll button timer
			this.scrollButtonTimer = new Timer(this.interval);
			this.scrollButtonTimer.addEventListener(TimerEvent.TIMER, scroll);
			
			//set the timer for thumb dragging
			this.thumbDragTimer = new Timer(this.interval);
			this.thumbDragTimer.addEventListener(TimerEvent.TIMER, onThumbDrag);
				
			//set the timer for gutter clicks
			this.gutterTimer = new Timer(this.interval);
			this.gutterTimer.addEventListener(TimerEvent.TIMER, onGutterDown);
			
			//if the buttons were not passed in, look for it
			if (rewindButton == null) {
				this.rewindButton = getChildByName("rewindButton") as MovieClip;
			}
			else {
				this.rewindButton = rewindButton;
			}
			
			if (forwardButton == null) {
				this.forwardButton = getChildByName("forwardButton") as MovieClip;
			}
			else {
				this.forwardButton = forwardButton;
			}
			
			if (thumbButton == null) {
				this.thumbButton = getChildByName("thumbButton") as MovieClip;
			}
			else {
				this.thumbButton = thumbButton;
			}
			
			if (gutter == null) {
				this.gutter = getChildByName("gutter") as MovieClip;
			}
			else {
				this.gutter = gutter;
			}
		}

		private function onAddedToStage(e:Event):void {
			if (this.outside == null && this.stage != null) {
				
				this.outside = this.stage;
				this.outside.addEventListener(MouseEvent.MOUSE_UP, stopDraggingThumb);
			}
		}

		public function setThumbOutside(outside:DisplayObject):void {
			if (this.outside != null) {
				this.outside.removeEventListener(MouseEvent.MOUSE_UP, stopDraggingThumb);
			}
			
			if (outside != null) {
				this.outside = outside;
				this.outside.addEventListener(MouseEvent.MOUSE_UP, stopDraggingThumb);
			}
		}

		public function setRewindButton(o:Sprite):void {
			this.rewindButton = o;
		}

		public function setForwardButton(o:Sprite):void {
			this.forwardButton = o;
		}

		public function setThumbButton(o:Sprite):void {
			this.thumbButton = o;
		}

		public function setGutter(o:Sprite):void {
			this.gutter = o;
		}

		public function setRewindButtonPosition(xPos:Number, yPos:Number):void {
			if (this.rewindButton != null) {
				this.rewindButton.x = xPos;
				this.rewindButton.y = yPos;
			}
		}

		public function setForwardButtonPosition(xPos:Number, yPos:Number):void {
			if (this.forwardButton != null) {
				this.forwardButton.x = xPos;
				this.forwardButton.y = yPos;
			}
		}

		/*
		 * Sets the position of the thumb and calls <code>adjustTargetPosition</code>
		 * when done
		 * @see #adjustTargetPosition(pos:Number)
		 */
		public function setThumbPosition(pos:Number):void {
			if (this.thumbButton != null) {
				
				//set the target according to this
				if (this.isVertical) {
					this.thumbButton.y = pos;
					adjustTargetPosition(this.thumbButton.y);
				}
				else {
					this.thumbButton.x = pos;
					adjustTargetPosition(this.thumbButton.x);
				}
			}
		}

		public function setGutterPosition(xPos:Number, yPos:Number):void {
			if (this.gutter != null) {
				this.gutter.x = xPos;
				this.gutter.y = yPos;
			}
		}

		public function setGutterSize(length:Number):void {
			if (this.isVertical) {
				this.gutter.height = length;
			}
			else {
				this.gutter.width = length;
			}
		}

		/*
		 * Refers to the number of pixels to move at a time if the target is not a text field
		 * If the target is a text field, this equals the number of lines to jump
		 */
		public function setScrollJump(jumpSize:int):void {
			this.jumpSize = jumpSize;
		}

		public function setSpeed(millis:uint):void {
			this.interval = millis;
		}

		/*
		 * Sets the target object to be scrolled
		 * @param scrollTarget - This <code>DisplayObject</code> can either be a <code>TextField</code> or other subclass
		 * @param boundaryStart - The coordinate of the viewable window for the scroll.  The value should be the left <code>x</code>
		 * coordinate if the scrolling is set to be horizontal or the top <code>y</code> coordinate if the scrolling is set to be vertical.
		 * @param boundaryEnd - Same as the boundaryStart except that the value should be the bottom <code>y</code> or right <code>x</code>
		 * @param thumbOutside - The object that will fire <code>MouseEvent.MOUSE_UP</code> events that will tell the thumb button to stop
		 * scrolling.  This is needed in case the user performs a "release outside".
		 */
		public function setTarget(scrollTarget:DisplayObject, 
			boundaryStart:Number = 0, boundaryEnd:Number = 0, thumbOutside:DisplayObject = null):void {
			//set the thumbOutside clip that will register mouse up events to stop
			//dragging the thumb if thumbOutside is not null
			if (thumbOutside != null) {
				this.outside = thumbOutside;
			}
			//thumbOutside is null
			else {
				//use stage if not null
				if (this.stage != null) {
					this.outside = this.stage;
				}
			}
			
			//if the target is a textfield
			if (scrollTarget is TextField) {
				//set the flag
				this.isTextField = true;
				
				//if this is vertical
				if (this.isVertical) {
					this.jumpSize = 1;
				}
				else {
					this.jumpSize = 15;
				}
						
				//set the scroll target
				this.scrollTargetText = scrollTarget as TextField;
				
				//get the boundary dimensions
				if (this.isVertical) {
					this.boundaryDimension = this.scrollTargetText.height;
					trace("bound dim is sdkfjskfskfjskjfkdsjfksdjk" + boundaryDimension)
				}
				else {
					this.boundaryDimension = this.scrollTargetText.width;
				}
			}
			//the scroll target is 
			else if (scrollTarget is DisplayObjectContainer) {
				//set the flag
				this.isTextField = false;
				
				//set the jump size
				this.jumpSize = 10;
							
				//set the scrolling target
				this.scrollTargetContainer = scrollTarget as DisplayObjectContainer;
				
				setBoundaries(boundaryStart, boundaryEnd);
			}			

			//enable or disable scroll as needed
			checkScroll();
				
			//adjust the thumb based on the 
			adjustThumbSize(getTargetSize(), this.boundaryDimension);
				
			//adjust the limits of the thumb movement, based on size of the thumb etc.
			setDefaultThumbLimits();
			
			update();
		}

		public function setBoundaries(boundaryStart:Number, boundaryEnd:Number):void {
			//scrolling will start from the top of the boundary
			this.scrollStart = boundaryStart;
				
			//get the proper dimensions of the boundary
			this.boundaryDimension = boundaryEnd - boundaryStart;
		}

		public function move(x:Number, y:Number):void {
			if (this.isVertical) {
				this.rewindButton.x = x;
				this.rewindButton.y = y;
				
				this.gutter.x = x;
				this.gutter.y = y + this.rewindButton.height;
				
				this.forwardButton.x = x;
				this.forwardButton.y = this.gutter.y + this.gutter.height;
				
				this.thumbButton.x = x;
				
			}
			else {
				this.rewindButton.x = x;
				this.rewindButton.y = y;
				
				this.gutter.y = y;
				this.gutter.x = x + this.rewindButton.width;
				
				this.forwardButton.y = y;
				this.forwardButton.x = this.gutter.x + this.gutter.width;
				
				this.thumbButton.y = y;
				
			}
			
			adjustThumbPosition();
		}

		/*
		 * Sets the size of the scroller.  Size is determined by taking
		 * the span of distance from the rewind button to the forward button.
		 * By default will also update gutter and scroll boundaries to defaults
		 */
		public function setSize(size:Number):void {
			var start:Number;
			var end:Number;
			
			//adjust starting from rewind button as registration point
			if (this.isVertical) {
				this.forwardButton.y = this.rewindButton.y + size - this.forwardButton.height;
				start = this.rewindButton.y;
				end = this.forwardButton.y + this.forwardButton.height;
			}
			else {
				this.forwardButton.x = this.rewindButton.x + size - this.forwardButton.width;
				start = this.rewindButton.x;
				end = this.forwardButton.x + this.forwardButton.width;
			}
			
			//adjust the gutters
			setDefaultGutter();
			
			//set the default scroll limits
			setDefaultThumbLimits();
			
			//update the boundaries of scroll window
			setBoundaries(start, end);
			
			//update the rest
			update();
		}

		/*
		 * Updates the scroll bar if the target or boundary size has changed.
		 * Will enable or disable scrolling as well as adjusting the thumb size
		 */
		public function update():void {
			//enable or disable scroll
			var enabled:Boolean = checkScroll();
			
			//if scroll enabled
			if (enabled) {
				//adjust the thumb size accordingly
				adjustThumbSize(getTargetSize(), this.boundaryDimension);
			
				//reposition thumb if out of bounds
				checkThumbBounds();
			
			
				if (this.thumbButton != null) {

					var thumbPos:Number;
			
					if (this.isVertical) {
						thumbPos = this.thumbButton.y;
					}
					else {
						thumbPos = this.thumbButton.x;
					}

					//readjust the target
					adjustTargetPosition(thumbPos);
				}
			}
		}

		private function checkThumbBounds():Boolean {
			if (this.thumbButton != null) {
				var out:Boolean = false;
				
				var thumbPos:Number;
				
				//get the relevant thumb pos and size
				if (this.isVertical) {
					thumbPos = this.thumbButton.y;
				}
				else {
					thumbPos = this.thumbButton.x;
				}
					
				//if out of bounds, reset
				if (thumbPos < this.thumbStart) {
					out = true;
					
					this.setThumbPosition(this.thumbStart);
				}
				else if (thumbPos > this.thumbEnd) {
					out = true;
					
					this.setThumbPosition(this.thumbEnd);
				}
				
				return out;
			}
			else {
				return false;
			}
			
		}

		/*
		 * Enable or disable the scroll as needed
		 */
		public function checkScroll():Boolean {
			if (this.isTextField) {
				//find out if max scroll
				var maxScroll:Number;
				
				if (this.isVertical) {
					maxScroll = this.scrollTargetText.maxScrollV;
				}
				else {
					maxScroll = this.scrollTargetText.maxScrollH;
				}
				
				//enable scroll if needed
				if (maxScroll > 1) {
					enableScroll();
					
					return true;
				}
				//otherwise disable scroll
				else {
					disableScroll();
					
					return false;
				}
			}
			else {
				//the dimensions difference between the target and the boundary
				//this is how much actually needs to scroll
				var boundaryTargetDiff:Number = getTargetSize() - this.boundaryDimension;
				
				//find the start and end limits of scrolling
				this.scrollEnd = this.scrollStart - boundaryTargetDiff;
				
				//if the target was smaller or equal to the boundary
				if (boundaryTargetDiff <= 0) {
					disableScroll();
					
					return false;
				}
				//otherwise enable scrolling
				else {
					enableScroll();
					
					return true;
				}
			}
		}

		/*
		 * Adjust the thumb size based on the sizes of the target and scroll boundary
		 */
		public function adjustThumbSize(targetSize:int, boundarySize:Number, minThumbSize:Number = 0):void {
			//only adjust if the target is larger than the boundary
			if (this.thumbButton != null && targetSize > boundarySize) {
				
				//if not specified use instance member's value
				if (minThumbSize == 0) {
					minThumbSize = this.minThumbSize;
				}
				
				//get the percentage the boundary is of the entire target
				var percentage:Number = boundarySize / targetSize;
				
				//make the thumb size proportional
				var tempDimension:Number = Math.round(getThumbScrollLength() * percentage);
				
				//dont make the thumb smaller than the min
				if (tempDimension < minThumbSize) {
					tempDimension = minThumbSize;
				}
				
				//adjust the proper dimension and thumb end
				if (this.isVertical) {
					this.thumbButton.height = tempDimension;
					this.thumbEnd = this.forwardButton.y - tempDimension;
				}
				else {
					this.thumbButton.width = tempDimension;	
					this.thumbEnd = this.forwardButton.x - tempDimension;
				}
				
				checkThumbBounds();
			}
		}

		/*
		 * Find the distance the thumb can move
		 */
		public function getThumbScrollLength():Number {
			if (this.isVertical) {
				return this.forwardButton.y - this.rewindButton.y - this.rewindButton.height;
			}
			else {
				return this.forwardButton.x - this.rewindButton.x - this.rewindButton.width;
			}
		}

		/*
		 * Set the flag to dictate whether this is vertically or horizontally scrolling
		 */
		public function setScrollVertical(verticalDirection:Boolean):void {
			this.isVertical = verticalDirection;
		}

		/*
		 * By default set the gutter to extend from the forward and rewind buttons
		 * Assumes that in a vertical scroll, rewind is on top of forward and in
		 * horizontal scroll, rewind is to the left of forward
		 */
		public function setDefaultGutter():void {
			//only set default gutter if forward and rewind buttons exist
			if (this.rewindButton != null && this.forwardButton != null && this.gutter != null) {
				//if scrolling vertically 
				if (this.isVertical) {
					//gutter starts from bottom of rewind button to top of forward button
					this.gutter.height = this.forwardButton.y - (this.rewindButton.y + this.rewindButton.height);
					this.gutter.y = this.rewindButton.y + this.rewindButton.height;
					this.gutter.x = this.rewindButton.x;
				}
				//scrolling horizontally
				else {
					this.gutter.width = this.forwardButton.x - (this.rewindButton.x + this.rewindButton.width);
					this.gutter.x = this.rewindButton.x + this.rewindButton.width;
					this.gutter.y = this.rewindButton.y;
				}
			}
		}

		/*
		 * Set the distance that the thumb button can move. By default it can move in between the
		 * forward and rewind buttons.  Should be called if the forward and rewind buttons change
		 */
		public function setDefaultThumbLimits():void {
			//if vertical scroll
			if (this.isVertical) {
				if (this.thumbButton != null) {
					
					if (this.rewindButton == null) {
						this.thumbStart = this.scrollStart;
					}
					else {
						//thumb starts at the bottom of the rewind button
						this.thumbStart = this.rewindButton.y + this.rewindButton.height;
					}
					
					if (this.forwardButton == null) {
						this.thumbEnd = this.scrollStart + this.boundaryDimension;
					}
					else {
						trace("ksdfjkdsjfksdfkdsjksdjfks sdfsdfsdf sdf sdkfsdjkfjsdkfjsdk fjs" + this.forwardButton.y + " " + this.forwardButton.height);
						//ends at top of forward
						this.thumbEnd = this.forwardButton.y - this.forwardButton.height;
					}
					
					//if thumb is outside limits
					if (this.thumbButton.y < this.thumbStart) {
						moveThumbStart();
					}
					else if (this.thumbButton.y > this.thumbEnd) {
						moveThumbEnd();
					}
				} 
			}
			//if horiz 
			else {
				//if thumb is outside limits
				if (this.thumbButton != null) {
					//thumb starts at left of rewind button
					this.thumbStart = this.rewindButton.x + this.rewindButton.width;
				
					//ends at left of forward
					this.thumbEnd = this.forwardButton.x - this.thumbButton.width;
				
					if (this.thumbButton.x < this.thumbStart) {
						moveThumbStart();
					}
					else if (this.thumbButton.x > this.thumbEnd) {
						moveThumbEnd();
					}
				} 
			}
		}

		/*
		 * Enable scrolling and adjust any visible aspect to represent an enabled scroll
		 */
		public function enableScroll():void {
			if (this.rewindButton != null) {
				this.rewindButton.addEventListener(MouseEvent.MOUSE_DOWN, onRewind);
				this.rewindButton.addEventListener(MouseEvent.MOUSE_UP, onStopScroll);
				this.rewindButton.addEventListener(MouseEvent.MOUSE_OUT, onStopScroll);
			}
			
			if (this.forwardButton != null) {
				this.forwardButton.addEventListener(MouseEvent.MOUSE_DOWN, onForward);
				this.forwardButton.addEventListener(MouseEvent.MOUSE_UP, onStopScroll);
				this.forwardButton.addEventListener(MouseEvent.MOUSE_OUT, onStopScroll);
			}
			
			if (this.thumbButton != null) {
				this.thumbButton.addEventListener(MouseEvent.MOUSE_DOWN, startDraggingThumb);
				this.thumbButton.addEventListener(MouseEvent.MOUSE_UP, stopDraggingThumb);
				
				if (this.outside != null) {
					this.outside.addEventListener(MouseEvent.MOUSE_UP, stopDraggingThumb);
				}
			}
			
			if (this.gutter != null) {
				this.gutter.addEventListener(MouseEvent.MOUSE_DOWN, startGutterMove);
				this.gutter.addEventListener(MouseEvent.MOUSE_OUT, stopGutterMovie);
				this.gutter.addEventListener(MouseEvent.MOUSE_UP, stopGutterMovie);
			}
			
			setEnabledDisplay();
		}

		/*
		 * Move the thumb button
		 */
		public function moveThumb(newThumbPos:Number):Number {
			
			//only move thumb if button is not null
			if (this.thumbButton != null) {
				if (newThumbPos < this.thumbStart) {
					newThumbPos = this.thumbStart;
				}
				else if (newThumbPos > this.thumbEnd) {
					newThumbPos = this.thumbEnd;
				}
				
				if (this.isVertical) {
					this.thumbButton.y = newThumbPos;
				}
				else {
					this.thumbButton.x = newThumbPos;
				}
			}
			
			return newThumbPos;
		}

		public function moveThumbEnd():void {
			moveThumb(this.thumbEnd);
			this.adjustTargetPosition(this.thumbEnd);
		}

		public function moveThumbStart():void {
			moveThumb(this.thumbStart);
			this.adjustTargetPosition(this.thumbStart);
		}

		/*
		 * Disables the scroll and adjusts any visible aspect of a disabled scroll
		 */
		public function disableScroll():void {
			if (this.rewindButton != null) {
				this.rewindButton.removeEventListener(MouseEvent.MOUSE_DOWN, onRewind);
				this.rewindButton.removeEventListener(MouseEvent.MOUSE_UP, onStopScroll);
				this.rewindButton.removeEventListener(MouseEvent.MOUSE_OUT, onStopScroll);
			}
			
			if (this.forwardButton != null) {
				this.forwardButton.removeEventListener(MouseEvent.MOUSE_DOWN, onForward);
				this.forwardButton.removeEventListener(MouseEvent.MOUSE_UP, onStopScroll);
				this.forwardButton.removeEventListener(MouseEvent.MOUSE_OUT, onStopScroll);
				
				if (this.outside != null) {
					this.outside.removeEventListener(MouseEvent.MOUSE_UP, stopDraggingThumb);
				}
			}
			
			setDisabledDisplay();
		}

		/*
		 * Adjust the display to represent a disabled scroll
		 */
		public function setDisabledDisplay():void {
		}

		/*
		 * Adjust the display to represent an enabled scroll
		 */
		public function setEnabledDisplay():void {
		}

		/*
		override public function set y(yCoord:Number):void {
		if (this.isVertical && this.rewindButton != null) {
		//find out delta from registration point
		var delta:Number = yCoord - this.rewindButton.y;
				
		this.rewindButton.y = yCoord;
				
		if (this.gutter != null) {
		this.gutter.y += delta;
		}
				
		if (this.forwardButton != null) {
		this.forwardButton.y += delta;
		}
				
		if (this.thumbButton != null) {
		this.thumbButton.y += delta;
					
		//reset the scroll limits
		setDefaultThumbLimits();
		}
		}
		}
		 */
		
		/*
		 * Get the relevant dimensions of the target.  Relevant relates to width or height of the 
		 * target depending on the scroll direction, horizontal or vertical, respectively.
		 * The dimensions returned if the target is a <code>TextField</code> will be <code>textHeight</code>
		 * or <code>textWidth</code> and <code>height</code> or <code>width</code> if the target is a
		 * <code>DisplayObjectContainer</code>.
		 */
		private function getTargetSize():Number {
			//not a textfield
			if (this.scrollTargetContainer != null) {
				if (this.isVertical) {
					return this.scrollTargetContainer.height;
				}
				else {
					return this.scrollTargetContainer.width;
				}
			}
			//this is a text field
			else {
				if (this.isVertical) {
					return this.scrollTargetText.textHeight;
				}
				else {
					return this.scrollTargetText.textWidth;
				}
			}
		}

		/*
		 * Adjust the thumb button's position based on the target position
		 */
		private function adjustThumbPosition():void {
			if (this.thumbButton != null) {
				if (this.isTextField) {
					//find the percent traveled
					var totalScroll:Number;
					var currentScroll:Number;
					
					if (this.isVertical) {
						totalScroll = this.scrollTargetText.maxScrollV - 1;
						currentScroll = this.scrollTargetText.scrollV - 1 ;
					}
					else {
						totalScroll = this.scrollTargetText.maxScrollH;
						currentScroll = this.scrollTargetText.scrollH;
					}
					
					var ratio:Number = currentScroll / totalScroll;
					
					//adjust thumb by this much
					if (this.isVertical) {
						this.thumbButton.y = this.thumbStart + ((this.thumbEnd - this.thumbStart) * ratio);
					}
					else {
						this.thumbButton.x = this.thumbStart + ((this.thumbEnd - this.thumbStart) * ratio);
					}
				}
				else {
					var pos:Number;
					
					//position
					if (this.isVertical) {
						pos = this.scrollTargetContainer.y;
					}
					else {
						pos = this.scrollTargetContainer.x;
					}
					
					//the total possible length of thumb travel
					var totalLength:Number = this.scrollStart - this.scrollEnd;
					
					//the actual amount traveled
					var totalTraveled:Number = this.scrollStart - pos;
					
					var ratio2:Number = totalTraveled / totalLength;
					
					if (this.isVertical) {
						this.thumbButton.y = Math.round(this.thumbStart + (ratio2 * (this.thumbEnd - this.thumbStart)));
					}
					else {
						this.thumbButton.x = Math.round(this.thumbStart + (ratio2 * (this.thumbEnd - this.thumbStart)));
					}
				}
			}
		}

		/*
		 * Adjusts the target position based on the position of the thumb
		 */
		private function adjustTargetPosition(thumbPos:Number):void {
			//the total possible length of thumb travel
			var totalLength:Number = this.thumbEnd - this.thumbStart;
			
			//the actual amount traveled
			var totalTraveled:Number = thumbPos - this.thumbStart;
			
			//the percentage the thumb traveled
			var ratio:Number = totalTraveled / totalLength; 

			//move the target by this percentage
			//if this is a text field
			if (this.isTextField) {
				//if vertical 
				if (this.isVertical) {
					this.scrollTargetText.scrollV = Math.round(ratio * this.scrollTargetText.maxScrollV);
				}
				//horizontal scroll
				else {
					this.scrollTargetText.scrollH = Math.round(ratio * this.scrollTargetText.maxScrollH);
				}
			}
			//if this is not a text field
			else {
				var scrollDistance:Number = (this.scrollEnd - this.scrollStart);
				
				//if vertical 
				if (this.isVertical) {
					this.scrollTargetContainer.y = Math.round(this.scrollStart + (ratio * scrollDistance));
				}
				//horizontal scroll
				else {
					this.scrollTargetContainer.x = Math.round(this.scrollStart + (ratio * scrollDistance));
				}
			}
		}

		/*
		 * Stop gutter clicks
		 */
		private function stopGutterMovie(me:MouseEvent):void {
			this.gutterTimer.stop();
		}

		/*
		 * Start gutter clicks
		 */
		private function startGutterMove(me:MouseEvent):void {
			this.gutterMouseEvent = me;
			
			//move the gutter one time before starting the timer
			onGutterDown(null);
			
			this.gutterTimer.start();
		}

		/*
		 * Move the thumb button
		 */
		private function onGutterDown(te:TimerEvent):void {
			//get the stage coordinates of the thumb
			var localPoint:Point = new Point(this.thumbButton.x, this.thumbButton.y);
			var globalPoint:Point = this.thumbButton.parent.localToGlobal(localPoint);
			
			//the global hit of the stage
			var stageHit:Number;
			var thumbPos:Number;
			
			//get the values depending on the scroll direction
			if (this.isVertical) {
				stageHit = this.gutterMouseEvent.stageY;
				thumbPos = globalPoint.y + (this.thumbButton.height) / 2;
			}
			else {
				stageHit = this.gutterMouseEvent.stageX;
				thumbPos = globalPoint.x + (this.thumbButton.width / 2);
			} 
			
			var movement:Number = stageHit - thumbPos;
			var newThumbPos:Number;
			
			//move by half
			if (this.isVertical) {
				newThumbPos = this.thumbButton.y + movement / 2;
			}
			else {
				newThumbPos = this.thumbButton.x + movement / 2;
			}
			
			//move the thumb
			newThumbPos = moveThumb(newThumbPos);
			adjustTargetPosition(newThumbPos);
		}

		/*
		 * Start dragging the thumb button
		 */
		private function startDraggingThumb(me:MouseEvent):void {
			//make a bounds from the rewind and forward buttons
			var rectangle:Rectangle;
			if (this.isVertical) {
				rectangle = new Rectangle(this.rewindButton.x, (this.rewindButton.y + this.rewindButton.height), 0, (this.forwardButton.y - (this.rewindButton.y + this.rewindButton.height) - this.thumbButton.height));
				trace("rectangle from sssssssssssss" + (this.rewindButton.y + this.rewindButton.height) + " " + (this.forwardButton.y - (this.rewindButton.y + this.rewindButton.height)) + " " + this.thumbButton.height);
				
			}
			else {
				rectangle = new Rectangle((this.rewindButton.x + this.rewindButton.width), this.rewindButton.y, (this.forwardButton.x - (this.rewindButton.x + this.rewindButton.width) - this.thumbButton.width), 0);
			}
			this.thumbDragTimer.start();
			this.thumbButton.startDrag(false, rectangle);
		}

		/*
		 * Stop dragging the thumb button
		 */
		private function stopDraggingThumb(me:MouseEvent):void {
			if (this.thumbButton != null) {
				this.thumbButton.stopDrag();
			}
			
			this.thumbDragTimer.stop();
		}

		private function onThumbDrag(te:TimerEvent):void {
			//if vertically scrolling adjust the y coordinate of the target
			if (this.isVertical) {
				this.adjustTargetPosition(this.thumbButton.y);
			}
			//otherwise adjust the x coordinate of the target
			else {
				this.adjustTargetPosition(this.thumbButton.x);
			}
		}

		private function onStopScroll(me:MouseEvent):void {
			//stop the scroll button timer
			this.scrollButtonTimer.stop();
		}

		private function onRewind(me:MouseEvent):void {
			//stop the scroll button timer
			this.scrollButtonTimer.stop();
			
			//set the direction
			this.direction = REWIND;
			
			//start the timer again
			this.scrollButtonTimer.start();
		}

		private function onForward(me:MouseEvent):void {
			//stop the scroll button timer
			this.scrollButtonTimer.stop();
			
			//set the direction
			this.direction = FORWARD;
			
			//start the timer
			this.scrollButtonTimer.start();
		}

		private function scroll(te:TimerEvent):void {
			//if vertical
			if (this.isVertical) {
				//the target is not a text field
				if (!this.isTextField) {
					//if moving forward
					if (this.direction == FORWARD) {
						//if able to move forward without overscrolling
						if (this.scrollTargetContainer.y - this.jumpSize >= this.scrollEnd) {
							//move the scroll forward by the jump size
							this.scrollTargetContainer.y -= this.jumpSize;
						}
						//otherwise move it to the end
						else {
							this.scrollTargetContainer.y = this.scrollEnd;
						}
					}
					//if moving backwards
					else {
						//if able to move back without overscrolling
						if (this.scrollTargetContainer.y + this.jumpSize <= this.scrollStart) {
							//move by the jump size
							this.scrollTargetContainer.y += this.jumpSize;
						}
						//otherwise move it to the beginning
						else {
							this.scrollTargetContainer.y = this.scrollStart;
						}
					}
					
					//adjust the thumb based on the target position
					adjustThumbPosition();
				}
				//the target is a text field
				else {
					//if the direction is down
					if (this.direction == FORWARD) {
						//if able to move forward without overscrolling
						if (this.scrollTargetText.scrollV + this.jumpSize <= this.scrollTargetText.maxScrollV) {
							//move by the jump size
							this.scrollTargetText.scrollV += this.jumpSize;
						}
						//move to the end
						else {
							this.scrollTargetText.scrollV = this.scrollTargetText.maxScrollV;
						}
					}
					//this direction back
					else {
						//if able to move back without overscrolling
						if (this.scrollTargetText.scrollV - this.jumpSize >= 0) {
							//move by the jump size
							this.scrollTargetText.scrollV -= this.jumpSize;
						}
						//move to the beginning
						else {
							this.scrollTargetText.scrollV = 0;
						}
					}
					
					//adjust the thumb based on the scroll position
					adjustThumbPosition();
				}
			}
			else {
				//the target is not a text field
				if (!this.isTextField) {
					//if moving forward
					if (this.direction == FORWARD) {
						//if able to move forward without overscrolling
						if (this.scrollTargetContainer.x - this.jumpSize >= this.scrollEnd) {
							this.scrollTargetContainer.x -= this.jumpSize;
						}
						//move it to the end
						else {
							this.scrollTargetContainer.x = this.scrollEnd;
						}
					}
					//if moving back
					else {
						//if able to move back without overscrolling
						if (this.scrollTargetContainer.x + this.jumpSize <= this.scrollStart) {
							this.scrollTargetContainer.x += this.jumpSize;
						}
						//move it to the beginning
						else {
							this.scrollTargetContainer.x = this.scrollStart;
						}
					}
					
					//adjust the thumb
					adjustThumbPosition();
				}
				//the target is a text field
				else {
					//if the direction is down
					if (this.direction == FORWARD) {
						//if able to move forward without overscrolling
						if (this.scrollTargetText.scrollH + this.jumpSize <= this.scrollTargetText.maxScrollH) {
							this.scrollTargetText.scrollH += this.jumpSize;
						}
						//move to the end
						else {
							this.scrollTargetText.scrollH = this.scrollTargetText.maxScrollH;
						}
					}
					//this direction back
					else {
						//if able to move back without overscrolling
						if (this.scrollTargetText.scrollH - this.jumpSize >= 0) {
							this.scrollTargetText.scrollH -= this.jumpSize;
						}
						//move to the beginning
						else {
							this.scrollTargetText.scrollH = 0;
						}
					}
					
					//adjust the thumb
					adjustThumbPosition();
				}
			}
		}
	}
}
