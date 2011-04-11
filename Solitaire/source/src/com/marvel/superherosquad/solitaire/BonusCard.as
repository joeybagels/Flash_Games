package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.AbstractBasicListButton;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	
	import gs.TweenLite;
	
	public class BonusCard extends AbstractBasicListButton implements IBonusCard
	{
		protected var count:uint;
		
		public var yeehaw:MovieClip;
		public var bubble:MovieClip;
		public var numBubble:MovieClip;
		
		public function BonusCard()
		{
			super();
			
			if (this.bubble != null) {
				this.bubble.visible = false;
			}
			
			if (this.numBubble != null) {
				this.numBubble.visible = false;
			}
			
			this.buttonMode = true;
			this.count = 0;
		}
		override public function set enabled(en:Boolean):void {
			super.enabled = en
		}

		public function helpBubble(title:String, text:String):void {
			trace("bubble is  " + bubble);
			if (this.bubble != null) {
				var tf:TextField = this.bubble.getChildByName("bubbleText") as TextField;
				tf.htmlText = "<b>" + title + "</b><br>" + text;
				
				this.bubble.visible = true;
				trace("showinghelp text " + text);
				TweenLite.delayedCall(6, removeBubble);
			}
		}
		
		public function removeBubble():void {
			this.bubble.visible = false;
		}
		
		public function increment():void {
			this.count++;
			
				if (this.yeehaw != null) {
					this.yeehaw.play();
				}
				
			if (this.count == 1) {
				gotoAndPlay("shine");
			}
			else {

				handleBubble();
			}
		}
		
		public function decrement():void {
			if (this.count > 0) {
				this.count--;
			}
			
			handleBubble();
		}
		
		public function setCount(count:uint):void {
			this.count = count;
			
			handleBubble();
		}
		
		public function getCount():uint {
			return this.count;
		}
		
		override public function get width():Number {
			return 69;
		}
		
		override public function get height():Number {
			return 76;
		}
		
		private function handleBubble():void {
			if (this.count < 2) {
				this.numBubble.visible = false;
			}
			else {
				this.numBubble.visible = true;
				var tf:TextField = this.numBubble.getChildByName("count") as TextField;
				tf.text = new String(this.count);
			} 
		}
	}
}