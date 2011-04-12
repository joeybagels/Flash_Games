package com.zerog.invasion {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.zerog.invasion.Score;
	
	public class GameOverDialog extends flash.display.MovieClip {
	
		// TODO: compare high scores and branch logic for showing submit dialog or not?
		
		// arbitrary default setting. Configure max length of "name" field here.
		private static const MAX_NAME_CHARS:uint = 10;
		
		private var passedInScore:String;
		
		
		public function GameOverDialog (tScore:String) {
			trace("recd: " + tScore);
			
			passedInScore = tScore;
			tfScore.text = passedInScore;
			
			btnSubmit.addEventListener(MouseEvent.CLICK, btnSubmitClicked);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, bgMouseDown);	
		}
	
		
		public function btnSubmitClicked(evt:MouseEvent){
			trace("high scores dialog close button clicked");
			// resource management cleanup -- kill listeners, remove children
			evt.target.removeEventListener(MouseEvent.MOUSE_DOWN, bgMouseDown);
			// whole shebang
			evt.target.removeEventListener(MouseEvent.CLICK, btnSubmitClicked);
			evt.target.parent.parent.removeChild(evt.target.parent);
			
			var nameCondensed = tfName.text.substring(0,MAX_NAME_CHARS-1);
			Score.getInstance().gameOver(nameCondensed,passedInScore);
		}
		
		public function bgMouseDown(evt:MouseEvent){
			trace("bg click through captured");
		}
		
	}
	
}
