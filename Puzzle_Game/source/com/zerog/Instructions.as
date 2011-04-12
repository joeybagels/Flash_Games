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
	
	
	public class Instructions extends MovieClip {
		private var shownFromGame:Boolean;
		
		
		function Instructions(shownFromGame:Boolean = false) {
			this.shownFromGame = shownFromGame;
			
			startButton.addEventListener(MouseEvent.CLICK, startButtonClicked);
		}
		
		
		private function startButtonClicked(mouseEvent:MouseEvent):void {
			if(!shownFromGame) {
				Object(parent).gotoGamePage();
			} else {
				Object(parent).hideInstructionsFromGame();
			}
		}
	}
}