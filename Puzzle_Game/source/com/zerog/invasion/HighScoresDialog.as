package com.zerog.invasion {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class HighScoresDialog extends flash.display.MovieClip {
		
		public function HighScoresDialog (test:String) {
			btnClose.addEventListener(MouseEvent.CLICK, btnCloseClicked);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, bgMouseDown);	
			
			var scoresArray = Score.getInstance().getScoresArray();
			
			for (var i:int = 0; i<10; i++){
				var thisRow = this["row"+i];
				var thisScoreObj = scoresArray[i];
				thisRow.tfRank.text = (i+1).toString();
				thisRow.tfName.text = thisScoreObj.name;
				thisRow.tfScore.text = thisScoreObj.score;
			}
			
		}
		
		public function btnCloseClicked(evt:MouseEvent){
			trace("high scores dialog close button clicked");
			// resource management cleanup -- kill listeners, remove children
			// mouse down
			evt.target.removeEventListener(MouseEvent.MOUSE_DOWN, bgMouseDown);
			// whole shebang
			evt.target.removeEventListener(MouseEvent.CLICK, btnCloseClicked);
			evt.target.parent.parent.removeChild(evt.target.parent);	
		}
		
		public function bgMouseDown(evt:MouseEvent){
			trace("bg click through captured");
		}
		

	}
	
}
