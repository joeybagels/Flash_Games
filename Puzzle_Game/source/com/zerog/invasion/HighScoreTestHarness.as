package com.zerog.invasion {
	import flash.display.*;
	// import flash.media.*;
	import flash.text.*;
	import flash.events.MouseEvent;
	import com.zerog.invasion.Score;
	import com.zerog.invasion.GameOverDialog;
	
	public class HighScoreTestHarness extends flash.display.MovieClip {
	
	
		public function HighScoreTestHarness() {
			stop();
			
			tfScore.text = (35 + Math.floor(Math.random()*75)).toString();
			
			// button click events
			btnGameStart.addEventListener(MouseEvent.CLICK,gameStart);
			btnLevelComplete.addEventListener(MouseEvent.CLICK,levelComplete);
			btnNewLevel.addEventListener(MouseEvent.CLICK,newLevel);
			btnGameOver.addEventListener(MouseEvent.CLICK,gameOver);
			btnIsHighScore.addEventListener(MouseEvent.CLICK,isHighScore);
			btnShowScores.addEventListener(MouseEvent.CLICK,showScores);
			btnClearScoreSO.addEventListener(MouseEvent.CLICK,clearScoreSO);
			btnDeleteScoreSO.addEventListener(MouseEvent.CLICK,deleteScoreSO);
			
		}
		
		// button click event handlers
		private function gameStart(evt:MouseEvent){
			Score.getInstance(evt.target.root);
			Score.getInstance().doSomething();
		};
		
		private function levelComplete(evt:MouseEvent){
			Score.getInstance().levelComplete(Number(tfLevelComplete.text));
		};
		private function newLevel(evt:MouseEvent){
			Score.getInstance().newLevel(Number(tfNewLevel.text));
		};
		private function gameOver(evt:MouseEvent){
			// display the Game Over, text entry screen.
			var gameOverDialog = new GameOverDialog(tfScore.text);
			gameOverDialog.x = -30;
			gameOverDialog.y = -30;
			evt.target.parent.addChild(gameOverDialog);
			// Score.getInstance().gameOver();
		};
		private function isHighScore(evt:MouseEvent){
			Score.getInstance().isHighScore(Number(tfScore.text));
		};
		private function showScores(evt:MouseEvent){
			Score.getInstance().showScores();
		};
		private function clearScoreSO(evt:MouseEvent){
			Score.getInstance().clearScoreSO();
		};		
		private function deleteScoreSO(evt:MouseEvent){
			Score.getInstance().deleteScoreSO();
		};		
		
	}
	
}
