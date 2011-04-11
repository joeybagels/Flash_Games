package com.zerog.components.dialogs {
	import com.zerog.components.dialogs.AbstractDialog;
	import com.zerog.events.DialogEvent;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Chris
	 */
	public class AbstractAlertDialog extends AbstractDialog {
		public var dismissButton:MovieClip;
		
		public function AbstractAlertDialog() {
			if (getQualifiedClassName(this) == "com.zerog.components.dialogs::AbstractAlertDialog") {
				throw new ArgumentError("AbstractAlertDialog can't be instantiated directly");
			}
			trace("this.dismiss " + this.dismissButton)
			this.dismissButton.addEventListener(MouseEvent.CLICK, onDismiss);
		}
		
		protected function onDismiss(e:MouseEvent):void {
			removeDialog();
			
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_DISMISS));
		}
	}
}
