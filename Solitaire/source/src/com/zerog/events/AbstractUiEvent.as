package com.zerog.events {
	import flash.events.MouseEvent;

	/**
	 * Abstract event for UI interaction.  Extends AbstractDataEvent but includes
	 * data for the source of the event
	 * 
	 * @author Chris Lam
	 */
	public class AbstractUiEvent extends AbstractDataEvent {
		private var mouseEvent:MouseEvent;

		public function AbstractUiEvent(type:String, data:Object = null, me:MouseEvent = null, 
			bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, data, bubbles, cancelable);

			this.mouseEvent = me;
		}

		public function getMouseEvent():MouseEvent {
			return this.mouseEvent;	
		}		
	}
}
