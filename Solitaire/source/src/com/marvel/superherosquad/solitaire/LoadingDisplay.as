package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.dialogs.AbstractLoadStreamDialog;
	import com.zerog.events.StreamEvent;
	import com.zerog.utils.load.ILoadStream;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class LoadingDisplay extends AbstractLoadStreamDialog
	{
		public var colorLogo:MovieClip;
		public var blocker:MovieClip;
		public var status:TextField;
		
		public function LoadingDisplay()
		{
			super();
		}
		
		override protected function onStatus(e:StreamEvent):void {
			var ls:ILoadStream = e.getStream();
			var percent:Number = ls.getBytesLoaded()/ls.getTotalBytes();
			setPercent(percent);
		}

		public function setDisplay(s:Sprite):void {
			this.colorLogo = s.getChildByName("colorLogo") as MovieClip;
			this.blocker = s.getChildByName("blocker") as MovieClip;
			this.status = s.getChildByName("status") as TextField;
			this.colorLogo.mask = this.blocker;
			addChild(s);
		}
		
		public function setPercent(percent:Number):void {
			if (this.blocker != null) {
				this.blocker.width = 600 * percent;
			} 
		}
		
		public function setStatus(statusText:String):void {
			
			trace("set status " + this.status + " ");
			if (this.status != null) {
				trace("set text " + this.status.text);
				this.status.text = statusText;
			}
		}
		override public function get height():Number {
			return 610;
		}
		override public function get width():Number {
			return 760;
		}
	}
}