package com.zerog.components.dialogs {
	import com.zerog.events.DialogEvent;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author Chris
	 */
	public class ConfirmDialog extends AlertDialog {
		public var proceedButton:MovieClip;

		public function ConfirmDialog(parentContainer:DisplayObjectContainer, buttonSpace:Number = 0, heading:String = null, message:String = null, width:Number = 0, html:Boolean = false) {
			super(parentContainer, heading, message, width, html);
			
			//center the buttons
			//find the combined width
			var w:Number = this.dismissButton.width + buttonSpace + this.proceedButton.width;
			
			this.dismissButton.x = (this.bg.width - w)/2;
			this.dismissButton.y = this.message.y + this.message.height + PADDING;
			this.proceedButton.x = this.dismissButton.x + this.dismissButton.width + buttonSpace;
			this.proceedButton.y = this.dismissButton.y;
			
			this.proceedButton.addEventListener(MouseEvent.CLICK, onProceed);
		}

		protected function onProceed(e:MouseEvent):void {
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_CONFIRM));
			
			removeDialog();
		}
	}
}
