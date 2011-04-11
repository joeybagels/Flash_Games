package com.marvel.superherosquad.solitaire
{
	import flash.display.MovieClip;

	public class Train extends MovieClip
	{
		public var smoke:MovieClip;
		public function Train()
		{
			super();
		}
		
		public function puffSmoke():void {
			this.smoke.play();
		}
		
		override public function get width():Number {
			return 247;
		}
		
	}
}