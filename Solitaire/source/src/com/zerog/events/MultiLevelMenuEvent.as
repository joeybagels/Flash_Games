package com.zerog.events {
	import com.zerog.events.AbstractDataEvent;

	/**
	 * @author Chris
	 */
	public class MultiLevelMenuEvent extends AbstractDataEvent {
		public static const ITEM_OVER:String = "itemOver";
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_OUT:String = "itemOut";

		public function MultiLevelMenuEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, data, bubbles, cancelable);
		}
	}
}
