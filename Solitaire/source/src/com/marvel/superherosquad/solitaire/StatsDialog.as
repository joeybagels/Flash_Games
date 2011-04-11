package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.dialogs.AbstractDialog;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class StatsDialog extends AbstractDialog
	{
		public var scores:TextField;
		public var close:BasicButton;
		public var resetStats:BasicButton;
		public static const CLOSE:String = "stats close";
		public static const RESET_STATS:String = "stats reset";
		public function StatsDialog()
		{
			super();
			
			this.resetStats.addEventListener(MouseEvent.CLICK, onResetStats);
			this.close.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		private function onResetStats(e:MouseEvent):void {
			trace("RESSET STATS");
			dispatchEvent(new Event(StatsDialog.RESET_STATS));
		}
		
		private function onClose(e:MouseEvent):void {
			dispatchEvent(new Event(StatsDialog.CLOSE));
			removeDialog();
		}
		
		public function setScores(drawOneHigh:Number, drawOnePercent:Number, drawThreeHigh:Number, drawThreePercent:Number,
			drawOneHighTimer:Number, drawOnePercentTimer:Number, drawThreeHighTimer:Number, drawThreePercentTimer:Number):void {
				
			drawOnePercent = Math.round(drawOnePercent*100);
			drawOnePercentTimer = Math.round(drawOnePercentTimer*100);
			
			drawThreePercent= Math.round(drawThreePercent*100);
			drawThreePercentTimer= Math.round(drawThreePercentTimer*100);
			
			var dop:String = "N/A";
			var dtp:String = "N/A";
			
			var dopt:String = "N/A";
			var dtpt:String = "N/A";
			
			if (drawOnePercent >= 0) {
				dop = new String(drawOnePercent) + "%";
			}
			
			if (drawThreePercent >= 0) {
				dtp = new String(drawThreePercent) + "%";
			}
			
			if (drawOnePercentTimer >= 0) {
				dopt = new String(drawOnePercentTimer) + "%";
			}
			
			if (drawThreePercentTimer >= 0) {
				dtpt = new String(drawThreePercentTimer) + "%";
			}

			this.scores.text = 
				drawOneHigh + "\n" + dop + "\n" + 
				drawOneHighTimer + "\n" + dopt + "\n\n\n\n\n" +

				drawThreeHigh + "\n" + dtp + "\n" +
				drawThreeHighTimer + "\n" + dtpt;
		}
	}
}