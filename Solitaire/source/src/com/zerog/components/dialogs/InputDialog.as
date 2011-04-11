package com.zerog.components.dialogs {
	import com.zerog.events.DialogEvent;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Chris
	 * 
	 * A basic input dialog with a text field to enter data, button to dismiss the dialog and send data, 
	 * a button to dismiss the dialog without sending the data, a header, and a body text field.
	 */
	public class InputDialog extends AbstractDialog {
		public var heading:TextField;
		public var input:TextField;
		public var proceedButton:MovieClip;
		public var dismissButton:MovieClip;
		
		public function InputDialog(parentContainer:DisplayObjectContainer, heading:String = null) {
			super();
			
			setParent(parentContainer);
			
			if (this.heading != null) {
				this.heading.text = heading;
			}
			
			if (this.input != null) {
				this.input.text = "";
			}
			
			this.proceedButton.addEventListener(MouseEvent.CLICK, onProceed);
			this.dismissButton.addEventListener(MouseEvent.CLICK, onDismiss);
		}
		
		override public function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void {
			super.showDialog(x, y);
			
			if (this.stage != null && this.input != null) {
				this.stage.focus = this.input;
			}
		}
		
		private function onDismiss(e:MouseEvent):void {
			removeDialog();
		}

		private function onProceed(e:MouseEvent):void {
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_CONFIRM, this.input.text));
			
			removeDialog();
		}
	}
}
