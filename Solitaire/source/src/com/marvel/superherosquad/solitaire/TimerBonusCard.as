package com.marvel.superherosquad.solitaire
{
	import com.zerog.utils.format.TimeFormat;
	
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.Event;
	
	public class TimerBonusCard extends BonusCard
	{
		private var timer:Timer;
		public var timeText:TextField;
		
		public static const TIME_BONUS_CARD_TICK:String = "time bonus card tick";
		
		public function TimerBonusCard()
		{
			super();
		}
		
		override public function setCount(count:uint):void {
			super.setCount(count);
			
			if (count > 0) {
				this.count = 1;
				trace('set count');
				startTimer();
			}
		}
		
		override public function increment():void {
			//super.increment();
			this.count = 1;

			startTimer();
		}
		
		private function startTimer():void {
			//start the timer
			if (this.timer == null) {
				this.timer = new Timer(1000, 5);
				this.timer.addEventListener(TimerEvent.TIMER, onTimer);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				this.timeText.text = TimeFormat.convertTime(5);
				trace("start timer");
				this.timer.start();
			}
		}
		
		private function onTimer(e:TimerEvent):void {
			trace(this.timer.currentCount);
			this.timeText.text = TimeFormat.convertTime(5 - this.timer.currentCount);
			trace("diuspatch");
			dispatchEvent(new Event(TIME_BONUS_CARD_TICK));
		}
		
		private function onTimerComplete(e:TimerEvent):void {
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			this.timer = null;
			
			dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
		}
	}
}