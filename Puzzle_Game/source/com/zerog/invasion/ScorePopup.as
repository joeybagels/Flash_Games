/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	import com.zerog.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	
	public class ScorePopup extends MovieClip {
		private var startY:Number;
		private var startTime:int;
		
		private var timer:Timer;
		
		
		public function initialize(x:Number, y:Number, score:int, combo:int):void {
			scoreText.scoreText.text = Config.SCOREPOPUP_PREFIX + score;
			comboText.text = combo.toString();
			
			if(combo == 0) {
				gotoAndStop("normal");
				comboText.visible = false;
			} else if(combo == 1) {
				gotoAndStop("combo");
				comboText.visible = false;
			} else {
				gotoAndStop("combos");
			}
			
			this.x = x;
			this.y = y;
			
			startY = y;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			startTime = NewTimer.getTimer();
			
			timer = new NewTimer(1, 0);
			timer.addEventListener(TimerEvent.TIMER, onMoveTime);
			timer.start();
		}
		
		
		private function onMoveTime(timerEvent:TimerEvent):void {
			var time:int = NewTimer.getTimer();
			var ratio:Number = (time - startTime) / Config.SCOREPOPUP_MOVETIME;
			
			if(ratio > 1) ratio = 1;
			
			timerEvent.updateAfterEvent();
			
			//this.y = startY - Math.sin(ratio * Math.PI) * Config.SCOREPOPUP_MOVEHEIGHT;
			var tY:Number = startY - (ratio * ratio * Config.SCOREPOPUP_MOVEHEIGHT);
			
			if (tY < 0) {
				tY = 0;
			}
			
			this.y = tY;
			//trace("y=" + y);
			
			if(ratio >= 1) {
				timer.stop();
				
				timer = new NewTimer(Config.SCOREPOPUP_STAYTIME, 1);
				timer.addEventListener(TimerEvent.TIMER, stayFinished);
				timer.start();
			}
		}
		
		private function stayFinished(timerEvent:TimerEvent):void {
			parent.removeChild(this);
		}
	}
}