package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.BasicButton;
	import com.zerog.components.dialogs.AbstractDialog;

	import flash.events.MouseEvent;

	public class HowToPlay extends AbstractDialog
	{
		public var close:BasicButton;
		public var nextB:BasicButton;
		public var back:BasicButton;
		
		public function HowToPlay()
		{
			super();
			stop();
			
			this.back.addEventListener(MouseEvent.CLICK, onBack);
			this.nextB.addEventListener(MouseEvent.CLICK, onNext);
			this.close.addEventListener(MouseEvent.CLICK, onClose);
		}
		private function adjustButtons():void {
			if (this.currentFrame == 1) {
				this.back.visible = false;
				this.nextB.visible = true;
			}
			else if (this.currentFrame == 4) {
				this.back.visible = true;
				this.nextB.visible = false;
			}
			else {
				this.back.visible = true;
				this.nextB.visible = true;
			}
		}
		override public function showDialogAt(x:Number = Number.NaN, y:Number = Number.NaN, index:int = 0):void {
			gotoAndStop(1);
			adjustButtons();
			
			super.showDialogAt(x,y,index);
			
		}
		private function onBack(e:MouseEvent):void {
			prevFrame();
						adjustButtons();
		}
		private function onNext(e:MouseEvent):void {
			nextFrame();
						adjustButtons();
		}
		private function onClose(e:MouseEvent):void {
			removeDialog();
		}
	}
}