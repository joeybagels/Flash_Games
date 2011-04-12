package com.zerog.invasion
{
	import com.zerog.components.buttons.BasicButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BottomBar extends MovieClip
	{
		/*
		public var deal:BasicButton;
		public var howToPlay:BasicButton;
		public var options:BasicButton;
		public var startGame:BasicButton;
		public var moreGames:BasicButton;
		public var heroes:BasicButton;
		*/
		public function BottomBar()
		{
			super();
			//removeChild(this.deal);
			//quit.visible = false;
			//startGame.addEventListener(MouseEvent.CLICK, onStartGame);
			
			/*
			this.howToPlay.buttonMode = true;
			this.options.buttonMode = true;
			this.startGame.buttonMode = true;
			this.moreGames.buttonMode = true;
			this.heroes.buttonMode = true;*/
		}
		
		public function onStartGame(e:MouseEvent):void {
			//removeChild(this.startGame);
			//quit.visible = true;
			Object(parent).menuStartGameEvent();
			if (startGame) {
				startGame.removeEventListener(MouseEvent.CLICK, onStartGame);
			}
			if (quit) {
				quit.removeEventListener(MouseEvent.CLICK, onQuitGame);
			}
			gotoAndPlay("normal");
			SoundManager.getInstance().play(SoundManager.SELECT_MENU);
		}
		public function onQuitGame(e:MouseEvent):void {
			SoundManager.getInstance().play(SoundManager.SELECT_MENU);
			
			//Object(parent).menuQuitGameEvent();
			
			quitConfirmation.gotoAndPlay("on");
		}
		public function quitDialogFrame():void {
			quitConfirmation.stop();
			quitConfirmation.quitBtn.addEventListener(MouseEvent.CLICK, onQuitConfirm);
			quitConfirmation.resumeBtn.addEventListener(MouseEvent.CLICK, onQuitResume);
		}
		
		public function onQuitConfirm(e:MouseEvent):void {
			SoundManager.getInstance().play(SoundManager.SELECT_MENU);
			quitConfirmation.quitBtn.removeEventListener(MouseEvent.CLICK, onQuitConfirm);
			quitConfirmation.resumeBtn.removeEventListener(MouseEvent.CLICK, onQuitResume);
			Object(parent).menuQuitGameEvent();
		}
		public function onQuitResume(e:MouseEvent):void {
			SoundManager.getInstance().play(SoundManager.SELECT_MENU);
			quitConfirmation.quitBtn.removeEventListener(MouseEvent.CLICK, onQuitConfirm);
			quitConfirmation.resumeBtn.removeEventListener(MouseEvent.CLICK, onQuitResume);
			quitConfirmation.gotoAndPlay("off");
		}
		
		public function normalFrame():void {
			quit.addEventListener(MouseEvent.CLICK, onQuitGame);
			stop();
		}
		public function replayFrame():void {
			startGame.addEventListener(MouseEvent.CLICK, onStartGame);
			stop();
		}
		
		public function showReplayMenu():void {
			if (startGame) {
				startGame.removeEventListener(MouseEvent.CLICK, onStartGame);
			}
			if (quit) {
				quit.removeEventListener(MouseEvent.CLICK, onQuitGame);
			}
			gotoAndPlay("replay");
		}
	}
}