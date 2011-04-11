package com.zerog.components.dialogs {
	import com.zerog.events.DialogEvent;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Chris
	 * 
	 * A basic alert style dialog with one button to dismiss the dialog, a title, and some body text
	 */
	public class AlertDialog extends AbstractAlertDialog {
		public var heading:TextField;
		public var message:TextField;
		
		public var headingBg:MovieClip;
		public var bg:MovieClip;
		public var dismissButton:MovieClip;
		
		protected var MIN_WIDTH:uint = 150;
		protected var MIN_HEIGHT:uint = 100;
		protected var PADDING:uint = 10;
		
		public function AlertDialog(parentContainer:DisplayObjectContainer, heading:String, message:String, width:Number = 0, html:Boolean = false) {
			super();
			
			setParent(parentContainer);
			
			this.dismissButton.addEventListener(MouseEvent.CLICK, onDismiss);
			
			//set the text
			this.heading.x = PADDING;
			this.heading.autoSize = TextFieldAutoSize.LEFT;
			this.heading.text = heading;
			this.message.autoSize = TextFieldAutoSize.LEFT;
			
			if (html) {
				this.message.htmlText = message;
			}
			else {
				this.message.text = message;
			}
			
			//if the width is not given, use the larger of the minimum or the width
			//of the header
			if (width == 0) {
				width = Math.max(MIN_WIDTH, this.heading.width + (PADDING * 2));
			}
			
			//adjust the width
			this.headingBg.width = width;
			this.bg.width = width;
			this.heading.x = PADDING;
			this.message.width = this.bg.width - PADDING * 2;
			this.message.x = PADDING;

			//center the message
			this.message.x = (this.bg.width - this.message.width)/2;
			
			//center the button
			this.dismissButton.x = (this.bg.width - this.dismissButton.width)/2;
			this.dismissButton.y = this.message.y + this.message.height + PADDING;
			
			//adjust the height
			if (this.dismissButton.y + this.dismissButton.height + PADDING < MIN_HEIGHT) {
				this.bg.height = MIN_HEIGHT;
			}
			else {
				this.bg.height = this.dismissButton.y + this.dismissButton.height + PADDING;
			}
		}
		

		protected function onDismiss(e:MouseEvent):void {
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_CONFIRM));
			
			removeDialog();
		}
	}
}
