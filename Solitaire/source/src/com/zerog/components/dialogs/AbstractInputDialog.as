package com.zerog.components.dialogs {
	import com.zerog.components.buttons.AbstractButton;
	import com.zerog.events.DialogEvent;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Chris
	 */
	public class AbstractInputDialog extends AbstractAlertDialog {
		public var confirmButton:MovieClip;

		public function AbstractInputDialog() {
			if (getQualifiedClassName(this) == "com.zerog.components.dialogs::AbstractInputDialog") {
				throw new ArgumentError("AbstractInputDialog can't be instantiated directly");
			}
			
			this.confirmButton.addEventListener(MouseEvent.CLICK, onConfirm);
		}

		protected function onConfirm(e:MouseEvent):void {
			removeDialog();
			
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_CONFIRM));
		}
	}
}
