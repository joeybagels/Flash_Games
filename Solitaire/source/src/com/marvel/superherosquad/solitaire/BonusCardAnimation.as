package com.marvel.superherosquad.solitaire
{
	import flash.display.MovieClip;

	public class BonusCardAnimation extends MovieClip
	{
		public function BonusCardAnimation()
		{
			super();
			gotoAndStop(1);
		}
		
		override public function play():void {
			trace("overide play");
			stop();
			gotoAndPlay(1);
		}
	}
}