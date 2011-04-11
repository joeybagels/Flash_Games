package com.zerog.events {
	import com.zerog.events.AbstractDataEvent;

	/**
	 * @author Chris
	 */
	public class ComponentEvent extends AbstractDataEvent {
		public static const UPDATED:String = "component updated";
		public function ComponentEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, data, bubbles, cancelable);
		}
	}
}
