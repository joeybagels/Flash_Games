/***************************************************************

	Copyright 2007, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/



package com.zerog {
	import flash.utils.*;
	import flash.events.*;
	
	
	public class NewTimer extends Timer {
		private static var paused:Boolean = false;
		private static var pauseTime:int;
		private static var totalPausedTime:int = 0;
		
		private var originalDelay:int;
		private var originalRepeatCount:int;
		
		private var listener:Function;
		
		private var adjustedStartTime:int;
		
		
		public static function getTimer():int {
			if(paused) {
				return pauseTime - totalPausedTime;
			} else {
				return flash.utils.getTimer() - totalPausedTime;
			}
		}
		
		public static function pause():void {
			if(paused) return;
			
			paused = true;
			pauseTime = flash.utils.getTimer();
		}
		
		public static function unpause():void {
			if(!paused) return;
			
			paused = false;
			totalPausedTime += flash.utils.getTimer() - pauseTime;
		}
		
		
		public function NewTimer(delay:Number, repeatCount:int = 0):void {
			super(delay, repeatCount);
			
			originalDelay = delay;
			originalRepeatCount = repeatCount;
		}
		
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			if(type != TimerEvent.TIMER) {
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
				return;
			}
			
			this.listener = listener;
			
			super.addEventListener(type, timerEventListener);
		}
		
		override public function start():void {
			adjustedStartTime = NewTimer.getTimer();
			
			super.start();
		}
		
		
		private function timerEventListener(timerEvent:TimerEvent):void {
			if(paused) {
				stop();
				
				delay = Math.max(originalDelay - (NewTimer.getTimer() - adjustedStartTime), 1);
				
				if(originalRepeatCount > 0) {
					repeatCount++;
				}
				
				super.start();
				
				return;
			}
			
			if(NewTimer.getTimer() - adjustedStartTime >= originalDelay) {
				adjustedStartTime = NewTimer.getTimer();
				
				if(delay != originalDelay) {
					stop();
					
					delay = originalDelay;
					
					super.start();
				}
				
				listener(timerEvent);
				
			} else {
				stop();
				
				delay = Math.max(originalDelay - (NewTimer.getTimer() - adjustedStartTime), 1);
				
				if(originalRepeatCount > 0) {
					repeatCount++;
				}
				
				super.start();
			}
		}
	}
}