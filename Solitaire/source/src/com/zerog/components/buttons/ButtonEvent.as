package com.zerog.components.buttons {
	import flash.events.MouseEvent;
	
	import com.zerog.events.AbstractUiEvent;		

	/**
	 * @author Chris
	 */
	public class ButtonEvent extends AbstractUiEvent {
		public static const DISABLED:String = "disabled";
		public static const ENABLED:String = "enabled";
		public static const SELECTED:String = "selected";
		public static const DESELECTED:String = "deselected";

		public function ButtonEvent(type:String, data:Object = null, me:MouseEvent = null, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, data, me, bubbles, cancelable);
		}
	}
}
