package com.zerog.events {
	import flash.events.MouseEvent;

	/**
	 * @author Chris
	 */
	public class DialogEvent extends AbstractUiEvent {
		public static const DIALOG_DISMISS:String = "dialogDismiss";
		public static const DIALOG_CONFIRM:String = "dialogConfirm";

		public function DialogEvent(type:String, data:Object = null, me:MouseEvent = null, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, data, me, bubbles, cancelable);
		}
	}
}
