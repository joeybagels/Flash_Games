/***************************************************************

	Copyright 2007, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/



package com.zerog {
	import flash.display.*;
	import flash.events.*;
	
	
	public class Title extends MovieClip {
		function Title() {
		//	startButton.addEventListener(MouseEvent.CLICK, startButtonClicked);
			//highScoresButton.addEventListener(MouseEvent.CLICK, highScoresButtonClicked);
			//moreGamesButton.addEventListener(MouseEvent.CLICK, moreGamesButtonClicked);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void {
			Object(parent).trackTitleView();
		}
		
		protected function startButtonClicked(mouseEvent:MouseEvent):void {
			//Object(parent).gotoInstructionsPage();
			Object(parent).gotoGamePage();
		}
		
		private function highScoresButtonClicked(mouseEvent:MouseEvent):void {
			Object(parent).showHighScores();
		}
		/*
		private function moreGamesButtonClicked(mouseEvent:MouseEvent):void {
			Object(parent).gotoMoreGamesURL();
		}
		*/
	}
}