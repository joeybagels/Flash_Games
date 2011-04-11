package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.BasicButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BottomBar extends MovieClip
	{
		public var deal:BasicButton;
		public var howToPlay:BasicButton;
		public var options:BasicButton;
		public var startGame:BasicButton;
		public var moreGames:BasicButton;
		public var undo:BasicButton;
		public var prizes:BasicButton;
		
		public function BottomBar()
		{
			super();
			//removeChild(this.deal);
			this.deal.visible = false;
			this.startGame.addEventListener(MouseEvent.CLICK, onStartGame);
			
			
			
			/*
			this.howToPlay.buttonMode = true;
			this.options.buttonMode = true;
			this.startGame.buttonMode = true;
			this.moreGames.buttonMode = true;
			this.heroes.buttonMode = true;*/
		}
		
		private function onStartGame(e:MouseEvent):void {
			removeChild(this.startGame);
			this.deal.visible = true;
		}
	}
}