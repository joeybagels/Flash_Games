package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.dialogs.AbstractDialog;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.MovieClip;
	
	public class CreditsPage extends AbstractDialog
	{
		public var generic:MovieClip;
		public var branded:MovieClip;
		
		public function CreditsPage()
		{
			this.branded.visible = false;
		}
		
		public function brand(url:String, x:Number, y:Number):void {
				var l:Loader = new Loader();
				l.x = x;
				l.y = y;
				l.load(new URLRequest(url));
				addChild(l);
				
				this.generic.visible = false;
				this.branded.visible = true;
		}

	}
}