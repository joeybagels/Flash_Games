/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	
	public class Message extends MovieClip {
		private var messageLevel:MessageLevel;
		private var messageLevelClear:MessageLevelClear;
		private var messagePlayAgain:MessagePlayAgain;
		
		private var tScore:Number;
		private var tWinLevel:Number;
		private var tWinHero:Number;
		
		function Message() {
			stop();
		}
		
		
		public function showLevel(level:int):void {
			hide();
			
			messageLevel = new MessageLevel();
			messageLevel.levelText.text = level.toString();
			
			this.addChild(messageLevel);
		}
		
		public function showNoMoreMoves():void {
			hide();
			
			//gotoAndStop("noMoreMoves");
		}
		
		public function showLevelClear(score:Number, nWin_Level:Number, nWin_Hero:Number):void {
			hide();
			
			tScore = score;
			tWinLevel = nWin_Level;
			tWinHero = nWin_Hero;
			
			messageLevelClear = new MessageLevelClear();
			//messageLevelClear.scoreText.text = Config.SCOREPOPUP_PREFIX + Config.SCORE_LEVEL;
			
			this.addChild(messageLevelClear);
		}
		public function dialogScoreScore():void {
			messageLevelClear.scoreText.text = tScore.toString();
		}
		public function dialogShowLevel():void {
			Object(parent).winDialogShowLevel();
			messageLevelClear.levelText.text = tWinLevel.toString();
		}
		public function dialogShowHero():void {
			Object(parent).winDialogShowHero();
			messageLevelClear.heroText.text = tWinHero.toString();
		}
		public function dialogShowTotal():void {
			Object(parent).winDialogShowTotal();
			messageLevelClear.totalText.text = (tScore + tWinLevel + tWinHero).toString();
		}
		
		public function showGameOver():void {
			hide();
			
			gotoAndPlay("gameOver");
		}
		public function gameOverFrame():void {
			this.scoreText.text = (Object(parent).score).toString();
		}
		public function gameOver2Frame():void {
			this.highScoreText.text = (Object(parent).getHighScore()).toString();
			stop();
		}
		
		public function showPlayAgain():void {
			Object(parent).showPlayAgainMenu();
			/*
			messagePlayAgain = new MessagePlayAgain();
			
			messagePlayAgain.playAgainButton.addEventListener(MouseEvent.CLICK, playAgainButtonClicked);
			messagePlayAgain.homeButton.addEventListener(MouseEvent.CLICK, homeButtonClicked);
			
			addChild(messagePlayAgain);
			*/
		}
		
		public function hide():void {
			if(messageLevel) {
				this.removeChild(messageLevel);
				messageLevel = null;
			}
			if(messageLevelClear) {
				this.removeChild(messageLevelClear);
				messageLevelClear = null;
			}
			
			gotoAndStop("hide");
		}
		
		private function playAgainButtonClicked(mouseEvent:MouseEvent):void {
			Object(parent).playAgainEvent();
			Object(parent.parent).gotoGamePage();
		}
		
		private function homeButtonClicked(mouseEvent:MouseEvent):void {
			Object(parent.parent).gotoTitlePage();
		}
	}
}